class CreatePhotoLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :photo_likes do |t|

      t.timestamps
    end
  end
end
