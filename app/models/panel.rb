class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations

  before_destroy :ensure_not_referenced_by_any_ann

  validates :number, presence: true
  validates :number, uniqueness: true

  def self.assign(ann, panel_and_location_hash)
    panel_number = panel_and_location_hash.delete(:panel)
    panel = find_or_initialize_by(number: panel_number)
    panel.assign(ann, panel_and_location_hash)
  end

  def assign(ann, location_hash)
    return false unless location = location_hash.delete(:to)
    raise InvalidArgument, "Unknown #{location_hash.keys.size == 1 ? "key" : "keys"}: #{location_hash.keys.join(", ")}" unless location_hash.size == 0
    begin
      ann.location = Location.new(ann: ann, panel: self, location: location)
    rescue ActiveRecord::RecordNotSaved
      return false
    end
    ann.errors.add(:panel_location, :blank) if ann.location and !ann.location.valid?
    ann.panel(true)
    ann.location
  end

  def assigned?(loc)
    Location.exists?(['location = ? and panel_id = ?', loc, self]) ? true : false
  end

  private

  def ensure_not_referenced_by_any_ann
    if anns.empty?
      return true
    else
      errors.add(:base, 'Anns present')
      return false
    end
  end
end
