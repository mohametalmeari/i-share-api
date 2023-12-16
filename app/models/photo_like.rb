class PhotoLike < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  validates_uniqueness_of :photo_id, scope: :user_id, message: 'already liked'
end
