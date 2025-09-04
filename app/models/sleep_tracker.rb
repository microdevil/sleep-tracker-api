class SleepTracker < ApplicationRecord
  belongs_to :user

  validates :slept_at, presence: true
end
