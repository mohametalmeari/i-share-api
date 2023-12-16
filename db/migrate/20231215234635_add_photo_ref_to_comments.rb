class AddPhotoRefToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :photo, null: false, foreign_key: true
  end
end
