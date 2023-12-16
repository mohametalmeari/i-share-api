class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, foreign_key: 'photo_id', dependent: :destroy
  has_many :photo_likes, foreign_key: 'photo_id', dependent: :destroy
  has_many :reposts, foreign_key: 'photo_id', dependent: :destroy
end
