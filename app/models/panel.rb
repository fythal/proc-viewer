class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations
end
