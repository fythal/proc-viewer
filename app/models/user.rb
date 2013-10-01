class User < ActiveRecord::Base
  has_many :logins
  has_many :searches

  validates! :name, presence: true
  validates! :name, uniqueness: true
end
