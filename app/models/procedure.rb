class Procedure < ActiveRecord::Base
  belongs_to :ann

  def latest_revision
    proc = self
    while (!proc.next_revision.nil?)
      proc = proc.next_revision
    end
    proc
  end

  def file_path
    path and Rails.public_path.join(path.sub(%r|^/|, "")).to_s
  end

  def system_path
    self.path.nil? ? nil : "#{Rails.public_path}#{self.path}"
  end

  def filename
    self.path.nil? ? nil : self.path.sub(%r|.*/|, "")
  end

  def construct_filename
    fn = []
    fn << (self.ann ? self.ann.procedure_header : Ann.procedure_dummy_header)
    fn << "r%03d" % (revision or 999)
    fn << Time.now.strftime('%Y-%m-%d-%H_%M_%S').to_s
    fn.join("-") + ".pdf"
  end

  def write(uploaded_file)
    pathname = Pathname.new("/procs")
    self.path = pathname.join(construct_filename).to_s
    File.open(self.system_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
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
