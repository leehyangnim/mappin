class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :post_likes, dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :post

  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A[\w+\-.?]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                    unless: :using_oauth?
  validates :uid, uniqueness: {scope: :provider}, if: :using_oauth?

  geocoded_by :ip_address
  after_validation :geocode, if: ->(obj){ obj.ip_address.present? and obj.ip_address_changed?}

  def using_oauth?
    uid.present? && provider.present?
  end

  serialize :facebook_raw_data, Hash

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

end
