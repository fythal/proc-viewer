class Location < ActiveRecord::Base
  belongs_to :panel
  belongs_to :ann

  def to_s
    location
  end
end
