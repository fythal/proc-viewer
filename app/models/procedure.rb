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
end
