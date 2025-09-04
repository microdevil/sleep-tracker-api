class User < ApplicationRecord
  has_many :sleep_trackers, dependent: :destroy
  has_many :active_relationships, class_name: "Follow",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Follow",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
