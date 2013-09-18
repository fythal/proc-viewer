# -*- coding: utf-8 -*-
class Ann < ActiveRecord::Base

#  validates_uniqueness_of :window, :scope => :panel, :message => I18n.t(:ann_already_assigned_to_other_ann)

  has_many :procedures
  has_one :location
  has_one :panel, through: :location

  validates :name, presence: true
  validates :name, uniqueness: true
  validate :panel_and_location_if_assigned

  def initialize(attributes = nil, &block)
    panel_number = nil
    location_number = nil

    if attributes.is_a?(Hash) and attributes[:panel].is_a?(String)
      panel_number = attributes.delete(:panel)
    end

    if attributes.is_a?(Hash) and attributes[:location].is_a?(String)
      location_number = attributes.delete(:location)
    end

    super

    unless panel_number.nil?
      self.panel = Panel.new(number: panel_number)
    end

    unless (location.nil?)
      self.location.location = location_number
    end

    self
  end

  def proc_path
    return nil if procedures.empty?
    procedures.first.latest_revision.path
  end

  def procedure
    procedures.last.latest_revision rescue nil
  end

  def panel_number
    panel.number rescue nil
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

  def assign(panel_and_location)
    panel = panel_and_location[:panel]
    location = panel_and_location[:location]
    if location.nil?
      self.errors.add(:panel_location, :blank)
      return false
    end

    panel = Panel.find_or_create_by(number: panel)

    self.panel.destroy if self.panel
    self.panel = panel
    self.location = location
    self.location.save
  end

  after_save do |ann|
    # 警報にパネル番号と窓が設定されている
    if !ann.panel.nil? and !ann.window.nil?
      # それにもかかわらず手順書がない
      if ann.procedures.empty?
        # それならば、手順書を新しくアサインしましょう
        proc = Procedure.new
        proc.ann = ann
        proc.path = "/assets/procs/ann-#{ann.panel.number}-#{ann.window}.pdf"
        proc.revised_on = Time.now
        if proc.save
          logger.info "A procedure of id #{proc.id} is created and assigned to ann of id #{ann.id}"
        else
          logger.info "Failed to save a procedure which is prepared for ann of id #{ann.id}"
        end
      end
    end
  end

  private

  def panel_and_location_if_assigned
    return true if location.nil?

    if panel.nil?
      errors.add(:panel_number, :blank)
    end

    if location.location.blank?
      errors.add(:panel_location, :blank)
    end

    errors.empty?
  end
end
