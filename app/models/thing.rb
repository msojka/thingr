class Thing < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :comments, -> { order(created_at: :desc) }
  
  scope :latest, -> { all.limit(9).order(id: :desc) }
  
end
