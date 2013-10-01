class Search < ActiveRecord::Base
  belongs_to :user

  validates! :keywords, presence: true
  validates! :user, presence: true
end
