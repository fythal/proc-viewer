# -*- coding: utf-8 -*-

# == 手順書のクラス
#
# 手順書を保持するクラス。警報に属しており、ファイルシステムでの手順書
# ファイルの管理をする。
#
# === 関連
#
# 手順書 (+Procedure+ オブジェクト) は警報 (+Ann+ オブジェクト) に属す
# る。警報は複数の手順書を持つことができ、それらは改定番号
# (+revision+) で区別される。
#
class Procedure < ActiveRecord::Base

  belongs_to :ann

  #
  # 最新の手順書を返す。同じ警報に属している他の手順書オブジェクトとの
  # 関係から最新の手順書を辿る。
  #
  # このアプリケーションの初期のデザインにあったが、+next_revision+ 属
  # 性自体が存在していないので、obsolete なメソッドである。
  #
  def latest_revision
    proc = self
    while (!proc.next_revision.nil?)
      proc = proc.next_revision
    end
    proc
  end

  #
  # この手順書オブジェクトに関連付けられている手順書ファイルのファイル
  # システムでのパスを返す。もし +path+ が設定されていない場合は +nil+
  # を返す。
  #
  #   procedure.file_path # => "/rails/root/public/procs/bar.pdf"
  #
  def file_path
    path and Rails.public_path.join(path.sub(%r|^/|, "")).to_s
  end

  #
  # この手順書オブジェクトに関連付けられている手順書ファイルのファイル
  # システムでのパスを返す。
  #
  #   procedure.system_path # => "/rails/root/public/procs/bar.pdf"
  #
  def system_path
    self.path.nil? ? nil : "#{Rails.public_path}#{self.path}"
  end

  #
  # この手順書オブジェクトに関連付けられている手順書ファイルのファイル
  # 名を返す。
  #
  #   procedure.filename # => "bar.pdf"
  #
  def filename
    self.path.nil? ? nil : self.path.sub(%r|.*/|, "")
  end

  #
  # 手順書のファイル名を生成して返す。ファイル名は以下の情報を含む。
  #  - 手順書の種別 (ann, aop, techspec)
  #  - 関連付けられているものを全体から識別するコード (警報パネルの場所や aop の章番号)
  #  - リビジョン番号
  #  - 手順書がアップロードされた日付
  #
  #   procedure.construct_filename # => "ann-n1-a1-r003-2013_10_10.pdf"
  #
  #   procedure.construct_filename # => "ann-zz-zz-r003-2013_10_10.pdf"
  #
  # 上記2番目の例は警報が警報パネルに割り当てられていない場合である。
  #
  def construct_filename
    fn = []
    fn << (self.ann ? self.ann.procedure_header : Ann.procedure_dummy_header)
    fn << "r%03d" % (revision or 999)
    fn << Time.now.strftime('%Y-%m-%d-%H_%M_%S').to_s
    fn.join("-") + ".pdf"
  end

  #
  # アップロードされたファイルをファイルシステムに保存する。
  # +uploaded_file+ は +:read+ メッセージを受け取り、ファイルのデータを
  # 返す。ファイルシステムへのファイル名は Procedure#+system_path+ で返
  # す値が使われる。
  #
  def write(uploaded_file)
    pathname = Pathname.new("/procs")
    self.path = pathname.join(construct_filename).to_s
    File.open(self.system_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end

  def update_path
    pathname = Pathname.new("/procs")
    self.path = pathname.join(construct_filename).to_s
  end

  private

  def path=(newname)
    newpath = "#{Rails.public_path}#{newname}"
    raise Errno::EEXIST, "File exists (#{newpath})" if File.exist?(newpath)
    begin
      File.rename(system_path, newpath)
    rescue
    ensure
      self[:path] = newname
    end
  end
end
