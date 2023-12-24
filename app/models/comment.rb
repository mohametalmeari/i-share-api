class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  has_many :replies, foreign_key: 'comment_id', dependent: :destroy
  has_many :comment_likes, foreign_key: 'comment_id', dependent: :destroy

  def count_likes
    CommentLike.where(comment: self).count
  end

  def count_replies
    Reply.where(comment: self).count
  end

  def liked?(user)
    CommentLike.where(comment: self, user:).exists?
  end
end
