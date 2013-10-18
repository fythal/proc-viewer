# -*- coding: utf-8 -*-
class Ann < ActiveRecord::Base

#  validates_uniqueness_of :window, :scope => :panel, :message => I18n.t(:ann_already_assigned_to_other_ann)

  has_many :procedures
  has_one :location
  has_one :panel, through: :location

  validates :name, presence: true
  validate :panel_and_location_if_assigned

  def procedure_header
    "ann-#{panel.nil? ? "zz" : panel.number}-#{(location.nil? or location.location.blank?) ? "zz" : location.location}"
  end

  def self.procedure_dummy_header
    "ann-zz-zz"
  end

  def proc_path
    return nil if procedures.empty?
    procedures.first.latest_revision.path
  end

  def procedure
    Procedure.where('ann_id = ?', self).order(:revision).last
  end

  def panel_number
    panel.number rescue location.panel.number rescue nil
  end

  def panel=(new_panel)
    raise NoMethodError
  end

  def location=(loc)
    if loc.is_a?(String)
      if self.location.nil?
        self.location = Location.new(location: loc)
      else
        self.location.location = loc
      end
    else
      super
    end
  end

  def panel_location
    location.location rescue nil
  end

  def rename_procedures
    procedures.each { |pr| pr.update_path }
  end

  private

  def panel_and_location_if_assigned
    errors.add(:panel_number, :blank) if panel_number_blank?
    errors.add(:panel_location, :blank) if panel_location_blank?

    case errors.count
    when 0
      return true
    when 1
      return false
    when 2
      errors.clear
      return true
    end
  end

  def panel_number_blank?
    begin
      return true if location.panel.nil? and panel.nil?
      return true if location.panel.number.blank? and panel.number.blank?
    rescue NoMethodError
      return true
    end
    false
  end

  def panel_location_blank?
    begin
      return true if location.location.blank?
    rescue NoMethodError
      return true
    end
    false
  end

  def self.search(keywords)
    Ann.where('name like ?', "%#{keywords}%").to_a
  end
end
