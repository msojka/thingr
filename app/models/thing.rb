class Thing < ActiveRecord::Base
  has_many :users
  has_many :comments, -> { order(created_at: :desc) }
  
  scope :latest, -> { all.limit(9).order(id: :desc) }
  
end
