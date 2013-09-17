class Location < ActiveRecord::Base
  belongs_to :panel
  belongs_to :ann

  validates :location, presence: true

  def to_s
    location
  end
end
