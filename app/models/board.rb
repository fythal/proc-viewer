class Board < ActiveRecord::Base
  has_many :panels

  def <=>(other)
    name <=> other.name
  end
end
