class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_many :reply_likes, foreign_key: 'reply_id', dependent: :destroy

  validates :content, presence: true

  def count_likes
    ReplyLike.where(reply: self).count
  end

  def liked?(user)
    ReplyLike.where(reply: self, user:).exists?
  end
end
