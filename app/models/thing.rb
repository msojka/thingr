class Thing < ActiveRecord::Base
  
  scope :latest, -> { all.limit(9).order("id DESC") }
  
end
