class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :photos, foreign_key: 'user_id', dependent: :destroy
  has_many :comments, foreign_key: 'user_id', dependent: :destroy
  has_many :replies, foreign_key: 'user_id', dependent: :destroy
  has_many :photo_likes, foreign_key: 'user_id', dependent: :destroy
  has_many :comment_likes, foreign_key: 'user_id', dependent: :destroy
  has_many :reply_likes, foreign_key: 'user_id', dependent: :destroy
  has_many :reposts, foreign_key: 'user_id', dependent: :destroy
end
