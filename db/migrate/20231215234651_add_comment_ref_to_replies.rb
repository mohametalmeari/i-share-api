class AddCommentRefToReplies < ActiveRecord::Migration[7.0]
  def change
    add_reference :replies, :comment, null: false, foreign_key: true
  end
end
