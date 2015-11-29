class AddUserThingReference < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :thing
    end
  end
end
