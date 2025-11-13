class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  validates :introduction, length: { maximum: 50 }
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  # プロフィール画像取得
  def get_profile_image(width = 100, height = 100)
    profile_image.attached? ? profile_image.variant(resize_to_limit: [width, height]) : 'no_image.jpg'
  end

  # フォロー機能
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
    #rel = relationships.find_by(followed_id: user.id)
    #rel.destroy if rel.present?
  end

  def following?(user)
    followings.include?(user)
  end
end