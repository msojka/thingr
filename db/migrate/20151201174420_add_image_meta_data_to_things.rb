class AddImageMetaDataToThings < ActiveRecord::Migration
  def change
    change_table :things do |t|
      t.text :image_meta_data
    end
  end
end
