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

  def write(uploaded_file)
    pathname = Pathname.new("/procs")
    self.path = pathname.join("#{ann.procedure_header}-#{revision ? "r%03d" % revision : "r999"}-#{Time.now.strftime('%Y-%m-%d-%H_%M_%S')}.pdf").to_s
    File.open(self.system_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end
end
