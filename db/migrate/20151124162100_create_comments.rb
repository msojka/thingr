class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :thing
      t.references :user
      t.text :body
      t.integer :weight
      t.timestamps null: false
    end
  end
end
