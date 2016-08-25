class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :post_likes, dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :post

  has_many :notifications, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A[\w+\-.?]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                    unless: :using_oauth?
  validates :uid, uniqueness: {scope: :provider}, if: :using_oauth?

  def using_oauth?
    uid.present? && provider.present?
  end

  PROVIDER_FACEBOOK = "facebook"
  PROVIDER_TWITTER = "twitter"

  serialize :facebook_raw_data, Hash
  serialize :twitter_raw_data, Hash

  def self.find_or_create_from_facebook(facebook_data)
    user = User.where(uid: facebook_data["uid"], provider: facebook_data["provider"] ).first
    user = create_from_facebook(facebook_data) unless user
    user
  end

  def self.create_from_facebook(facebook_data)
    user = User.new
    user.email = facebook_data["info"]["email"]
    user.uid = facebook_data["uid"]
    user.provider = facebook_data["provider"]
    user.facebook_token = facebook_data["credentials"]["token"]
    user.facebook_expires_at = facebook_data["credentials"]["expires_at"]
    user.facebook_raw_data = facebook_data
    user.password = SecureRandom.urlsafe_base64
    user.save!
    user
  end


  def self.find_or_create_from_twitter(twitter_data)
    user = User.where(uid: twitter_data["uid"], provider: twitter_data["provider"]).first
    user = create_from_twitter(twitter_data) unless user
    user
  end

  def self.create_from_twitter(twitter_data)
    user = User.new
    user.email = twitter_data["info"]["nickname"]
    user.uid = twitter_data["uid"]
    user.provider = twitter_data["provider"]
    user.twitter_consumer_token = twitter_data["credentials"]["token"]
    user.twitter_consumer_secret = twitter_data["credentials"]["secret"]
    user.twitter_raw_data = twitter_data
    user.password = SecureRandom.urlsafe_base64
    user.save!
    user
  end

  def using_facebook?
      using_oauth? && provider == PROVIDER_FACEBOOK
  end

  def using_twitter?
      using_oauth? && provider == PROVIDER_TWITTER
  end


end
