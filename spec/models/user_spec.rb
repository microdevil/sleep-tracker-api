require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with name and email" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end
end
