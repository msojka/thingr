class User < ActiveRecord::Base
  serialize :auth_meta_data
  
  has_many :things, through: :authorships
  has_many :authorships
end