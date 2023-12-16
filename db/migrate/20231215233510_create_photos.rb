class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image_url
      t.text :caption
      t.boolean :archive, default: false

      t.timestamps
    end
  end
end
