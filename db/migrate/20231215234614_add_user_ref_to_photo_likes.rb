class AddUserRefToPhotoLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :photo_likes, :user, null: false, foreign_key: true
  end
end
