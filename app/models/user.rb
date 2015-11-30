class User < ActiveRecord::Base
  has_many :things, through: :authorships
  has_many :authorships
end