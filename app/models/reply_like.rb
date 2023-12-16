class ReplyLike < ApplicationRecord
  belongs_to :user
  belongs_to :reply
end
