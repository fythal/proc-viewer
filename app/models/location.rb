class Location < ActiveRecord::Base
  belongs_to :panel
  belongs_to :ann

  validates :location, presence: true
  validates_presence_of :ann, :panel, :x, :y
  validates_uniqueness_of :x, scope: [:panel_id, :y]
  validates_uniqueness_of :y, scope: [:panel_id, :x]

  def to_s
    location
  end

  def location=(loc)
    case loc
    when /([a-h])(\d+)/i
      self.x = $~[2].to_i
      self.y = $~[1].tr('a-hA-H', '1-81-8').to_i
    when /(\d+)([a-h])/i
      self.x = $~[1].to_i
      self.y = $~[2].tr('a-hA-H', '1-81-8').to_i
      loc = $~[2] + $~[1]
    end
    super
  end

  def x=(value)
    super
    if x.kind_of?(Integer) and y.kind_of?(Integer)
      self[:location] = y.to_s.tr('1-8', 'a-h') + x.to_s
    end
  end

  def y=(value)
    super
    if x.kind_of?(Integer) and y.kind_of?(Integer)
      self[:location] = y.to_s.tr('1-8', 'a-h') + x.to_s
    end
  end
end
