class AddPhotoRefToReposts < ActiveRecord::Migration[7.0]
  def change
    add_reference :reposts, :photo, null: false, foreign_key: true
  end
end
