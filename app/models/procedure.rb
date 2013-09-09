class Procedure < ActiveRecord::Base
  belongs_to :ann
  belongs_to :prev_revision, :class_name => Procedure
  has_one :next_revision, :class_name => Procedure, :foreign_key => "prev_revision_id"

  def latest_revision
    proc = self
    while (!proc.next_revision.nil?)
      proc = proc.next_revision
    end
    proc
  end
end
