class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  geocoded_by :address
  after_validation :geocode

end
