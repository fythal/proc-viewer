class Panel < ActiveRecord::Base
  has_many :locations
  has_many :anns, through: :locations

  before_destroy :ensure_not_referenced_by_any_ann

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
