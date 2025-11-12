class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  validates :introduction, length: { maximum: 200 }
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true

  # フォローする側
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  # フォローされる側
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # プロフィール画像取得
  def get_profile_image(width = 100, height = 100)
    profile_image.attached? ? profile_image.variant(resize_to_limit: [width, height]) : 'no_image.jpg'
  end

  # フォロー機能
  def follow(other_user)
    relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end
end