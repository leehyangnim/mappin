class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :users, through: :post_likes
  has_many :notifications, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  mount_uploader :image, ImageUploader

  geocoded_by :address
  after_validation :geocode

  def liked_by?(user)
    post_likes.exists?(user: user)
  end

  def like_for(user)
    post_likes.find_by_user_id user
  end

end
