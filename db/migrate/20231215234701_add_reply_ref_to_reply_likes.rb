class AddReplyRefToReplyLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :reply_likes, :reply, null: false, foreign_key: true
  end
end
