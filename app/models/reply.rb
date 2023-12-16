class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_many :reply_likes, foreign_key: 'reply_id', dependent: :destroy
end
