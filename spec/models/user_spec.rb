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

  describe "follower and following associations" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "can follow another user" do
      user.followings << other_user
      expect(user.followings).to include(other_user)
    end

    it "can be followed by another user" do
      other_user.followings << user
      expect(user.followers).to include(other_user)
    end
  end
end
