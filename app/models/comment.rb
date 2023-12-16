class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  has_many :replies, foreign_key: 'comment_id', dependent: :destroy
  has_many :comment_likes, foreign_key: 'comment_id', dependent: :destroy
end
