class Location < ActiveRecord::Base
  belongs_to :panel
  belongs_to :ann
end
