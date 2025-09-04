
require 'rails_helper'

RSpec.describe SleepTracker, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'is valid with valid attributes' do
    sleep_tracker = SleepTracker.new(user: user, slept_at: 8.hours.ago)
    expect(sleep_tracker).to be_valid
  end

  it 'is invalid without a user' do
    sleep_tracker = SleepTracker.new(slept_at: 8.hours.ago)
    expect(sleep_tracker).not_to be_valid
  end

  # duration calculation is not present in the current model

  it 'is invalid without slept_at' do
    sleep_tracker = SleepTracker.new(user: user)
    expect(sleep_tracker).not_to be_valid
  end
end
