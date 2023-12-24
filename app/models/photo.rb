class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, foreign_key: 'photo_id', dependent: :destroy
  has_many :photo_likes, foreign_key: 'photo_id', dependent: :destroy
  has_many :reposts, foreign_key: 'photo_id', dependent: :destroy

  validates :caption, presence: true
  validates :image_url, presence: true

  def count_likes
    PhotoLike.where(photo: self).count
  end

  def count_comments
    comments = Comment.where(photo: self)
    count = comments.count
    comments.map do |comment|
      count += Reply.where(comment:).count
    end
    count
  end

  def liked?(user)
    PhotoLike.where(photo: self, user:).exists?
  end
end
