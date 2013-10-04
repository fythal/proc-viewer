class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations
  belongs_to :board

  before_destroy :ensure_not_referenced_by_any_ann

  validates :number, presence: true
  validates :number, uniqueness: true

  def self.assign(ann, panel_and_location)
    panel = relating(panel_and_location[:panel])
    location = Location.new(ann: ann, panel: panel, location: panel_and_location[:to])

    begin
      ann.location = location
    rescue ActiveRecord::RecordNotSaved
      return false
    end
    ann.panel(true)
    ann.location.valid?
  end

  def assign(ann, location_hash)
    Panel.assign(ann, location_hash.merge(panel: self))
  end

  def assigned?(loc)
    Location.exists?(['location = ? and panel_id = ?', loc, self]) ? true : false
  end

  def height
    locmax = max_height_of_locations
    _height.nil? ? locmax : [_height, locmax].max
  end

  def max_height_of_locations
    return 0 if locations.empty?
    locations.map(&:y).max
  end

  def width
    locmax = max_width_of_locations
    _width.nil? ? locmax : [_width, locmax].max
  end

  def max_width_of_locations
    return 0 if locations.empty?
    locations.map(&:x).max
  end

  def height=(value)
    _height = value
  end

  def width=(value)
    _width = value
  end

  private

  def self.relating(specifier)
    case specifier
    when Panel
      specifier
    when String
      find_or_initialize_by(number: specifier)
    else
      nil
    end
  end

  def ensure_not_referenced_by_any_ann
    if anns.empty?
      return true
    else
      errors.add(:base, 'Anns present')
      return false
    end
  end
end
