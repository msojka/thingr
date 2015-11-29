class AddUserThingReference < ActiveRecord::Migration
  def change
    create_join_table :things, :users
  end
end
