class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations

  def assigned?(loc)
    Location.exists?(['location = ? and panel_id = ?', loc, self]) ? true : false
  end
end
