# -*- coding: utf-8 -*-
class Ann < ActiveRecord::Base

  validates_uniqueness_of :window, :scope => :panel, :message => I18n.t(:ann_already_assigned_to_other_ann)

  has_many :procedures
  has_one :location
  has_one :panel, through: :location

  def proc_path
    return nil if procedures.empty?
    procedures.first.latest_revision.path
  end

  after_save do |ann|
    # 警報にパネル番号と窓が設定されている
    if !ann.panel.nil? and !ann.window.nil?
      # それにもかかわらず手順書がない
      if ann.procedures.empty?
        # それならば、手順書を新しくアサインしましょう
        proc = Procedure.new
        proc.ann = ann
        proc.path = "/assets/procs/ann-#{ann.panel}-#{ann.window}.pdf"
        proc.revised_on = Time.now
        if proc.save
          logger.info "A procedure of id #{proc.id} is created and assigned to ann of id #{ann.id}"
        else
          logger.info "Failed to save a procedure which is prepared for ann of id #{ann.id}"
        end
      end
    end
  end
end
