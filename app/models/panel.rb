# -*- coding: utf-8 -*-

# == 警報パネル
#
# 警報パネル (Panel オブジェクト) は、警報のコンテナである。警報が配置
# される場所は、警報の「リンク」となっている場所 (Location オブジェクト)
# が保持する。
#
# === 属性
# - number (+String+): 警報パネルの名称
# - _height, _width (+Integer+): 警報パネルのデフォルトの高さおよび幅
# - board_id (+Integer+): 盤 (Board オブジェクト) への関連
#
# === 関連
# - locations (場所)
# - anns (場所を介する)
# - board (警報パネルが所属する盤)
#
# === 妥当性
# Panel オブジェクトの妥当性は以下の条件に関して評価される。
#
# - number は存在している。
# - number は独自の値を持つ。

class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations
  belongs_to :board

  before_destroy :ensure_not_referenced_by_any_ann

  validates :number, presence: true
  validates :number, uniqueness: true

  alias_method :anns_orig, :anns

  #
  # 警報パネルに警報を割り当てるクラスメソッド
  #
  def self.assign(ann, panel_and_location)
    return false if panel_and_location[:panel].nil? or panel_and_location[:to].nil?

    panel = relating(panel_and_location[:panel])

    # 割り当てようとする場所 (文字列)
    assigning_location = panel_and_location[:to]

    # 元の場所は削除する
    ann.location.destroy if ann.location.present? and ann.location.location != assigning_location

    search_param = { panel_id: panel.id, location: assigning_location }
    if panel.persisted?
      # パネルから場所オブジェクトがすでに作成されていないか探してみる。なかったら作る
      location = Location.find_or_initialize_by(search_param) { |loc| loc.ann = ann }
    else
      # パネルが新設の場合、場所オブジェクトも作成する
      location = Location.new(ann: ann, panel: panel, location: assigning_location)
    end

    begin
      # ann がデータベースに保存されていなくても ann から場所にアクセス
      # できるようにする
      ann.location = location
    rescue ActiveRecord::RecordNotSaved
      return false
    end
    ann.panel(true)

    if ann.location.valid?
      ann.rename_procedures
      true
    else
      false
    end
  end

  #
  # 警報パネルに警報を割り当てるインスタンスメソッド
  #
  def assign(ann, location_hash)
    Panel.assign(ann, location_hash.merge(panel: self))
  end

  #
  # 警報が loc の場所に割り当てられていれば true を返す。loc は文字列で指定する。
  #
  def assigned?(loc)
    Location.exists?(['location = ? and panel_id = ?', loc, self]) ? true : false
  end

  #
  # 警報パネルの高さを返す。
  #
  # 警報パネルには元々の高さを設定する属性 _height があるが、もしこの高
  # さ以上のところに警報が割り当てられた場合、警報がすべて収まる高さを
  # 返す。
  #
  def height
    locmax = max_height_of_locations
    _height.nil? ? locmax : [_height, locmax].max
  end

  def max_height_of_locations
    return 0 if locations.empty?
    locations.map(&:y).max
  end

  #
  # 警報パネルの幅を返す。
  #
  # 警報パネルには元々の幅を設定する属性 _width があるが、もしこの幅以
  # 上のところに警報が割り当てられた場合、警報がすべて収まる幅を返す。
  #
  def width
    locmax = max_width_of_locations
    _width.nil? ? locmax : [_width, locmax].max
  end

  def max_width_of_locations
    return 0 if locations.empty?
    locations.map(&:x).max
  end

  #
  # 警報パネルの高さを設定する。
  #
  # この設定値は _height 属性に保存される。このメソッドに対応する
  # アクセサに height があるが、これは、もし警報が高さ以上のところに設
  # 定されていた場合、その警報の高さを含む値を返す。
  #
  def height=(value)
    self._height = value
  end

  #
  # 警報パネルの高さを設定する。
  #
  # この設定値は _width 属性に保存される。このメソッドに対応する
  # アクセサに width があるが、これは、もし警報が幅以上のところに設定さ
  # れていた場合、その警報の幅を含む値を返す。
  #
  def width=(value)
    self._width = value
  end

  #
  # 関連付けられている警報を返す。has_many を指定したときに自動的に設定
  # されるメソッドと同じであるが、引数に :array を含むハッシュが渡され
  # たときは、2次元配列を返す。警報パネルへの警報の割り当てに対応してお
  # り、割り当てられているところには Ann オブジェクトが設定される。
  # 割り当てられていない場所には nil が設定される。
  #
  def anns(value = false)
    if value.kind_of?(Hash)
      if value[:array]
        (1..height).inject([]) do |result, y|
          result << (1..width).inject([]) do |result, x|
            loc = locations.where('x = ? and y = ?', x, y).first
            result << (loc.nil? ? nil : loc.ann)
          end
        end
      end
    else
      anns_orig(value)
    end
  end

  def <=>(other)
    number <=> other.number
  end

  private

  #
  # 警報パネルを返すクラスメソッド。引数によって挙動が異なる。
  # 警報パネルオブジェクトが指定されたときは、それ自身を返す。文字列が
  # 指定された場合、それを number 属性に持つ警報パネルが存在すれば、そ
  # れを返し、また存在しなかったら、新規にオブジェクトを作成して返す。
  # それ以外のクラスのオブジェクトが渡されたときは nil を返す。
  #
  def self.relating(specifier)
    case specifier
    when Panel
      specifier
    when String
      find_or_initialize_by(number: specifier)
    else
      nil
    end
  end

  #
  # 警報が一つもパネルに配置されていないことを確認するメソッド。もし配
  # 置されている警報があった場合、警報パネルオブジェクト自体にエラーを
  # つける。
  #
  def ensure_not_referenced_by_any_ann
    if anns.empty?
      return true
    else
      errors.add(:base, 'Anns present')
      return false
    end
  end
end
