# -*- coding: utf-8 -*-

# == 警報パネルの場所
#
# 場所 (Location オブジェクト) は、警報パネル (Panel オブジェクト) と、
# 警報 (Ann オブジェクト) または一括警報 (Panel オブジェクト) を関連付
# ける。
#
# === 属性
# - item_id (+Integer+)
# - item_type (+String+)
# - panel_id (+Integer+)
# - location (+String+)
# - x (+Integer+)
# - y (+Integer+)
#
# === 妥当性
# Location オブジェクトの妥当性は以下の条件に関して評価される。
#
# - item_id が設定され、かつオブジェクト (Ann または Panel) が存在している。 (polymorphic)
# - panel_id が設定され、かつオブジェクトが存在している。
# - location が設定されている。
# - x, y が設定されている。
# - 同じ警報パネルに属する Location オブジェクトについて、x と y の独自性を持っている。

class Location < ActiveRecord::Base
  belongs_to :panel
  belongs_to :item, polymorphic: true

  validates :location, presence: true
  validates_presence_of :item
  validates_presence_of :panel, :x, :y
  validates_uniqueness_of :x, scope: [:panel_id, :y]
  validates_uniqueness_of :y, scope: [:panel_id, :x]

  #
  # location 属性を返す。location は警報パネルの座標を示す文字列 ('a1'
  # など)。
  #
  def to_s
    location
  end

  #
  # location 属性を設定する。引数は文字列で指定する ("a1" や "1a" など)。
  # 場所の属性については x と y があるが、これらも同時に更新する。
  #
  def location=(loc)
    case loc
    when /([a-h])(\d+)/i
      self.x = $~[2].to_i
      self.y = $~[1].tr('a-hA-H', '1-81-8').to_i
    when /(\d+)([a-h])/i
      self.x = $~[1].to_i
      self.y = $~[2].tr('a-hA-H', '1-81-8').to_i
      loc = $~[2] + $~[1]
    end
    super
  end

  #
  # 水平方向の座標を指定する。値を設定するときに y も設定されていれば、
  # location 属性も設定する。
  #
  def x=(value)
    super
    if x.kind_of?(Integer) and y.kind_of?(Integer)
      self[:location] = y.to_s.tr('1-8', 'a-h') + x.to_s
    end
  end

  #
  # 垂直方向の座標を指定する。値を設定するときに x も設定されていれば、
  # location 属性も設定する。
  #
  def y=(value)
    super
    if x.kind_of?(Integer) and y.kind_of?(Integer)
      self[:location] = y.to_s.tr('1-8', 'a-h') + x.to_s
    end
  end
end
