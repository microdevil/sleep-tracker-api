class User < ApplicationRecord
  has_many :sleep_trackers, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
