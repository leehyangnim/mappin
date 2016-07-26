class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A[\w+\-.?]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i



  geocoded_by :ip_address
  after_validation :geocode, if: ->(obj){ obj.ip_address.present? and obj.ip_address_changed?}

  def full_name
    "#{first_name} #{last_name}"
  end
end
