require 'rails_helper'

RSpec.describe Follow, type: :model do
  it "is valid with follower and followed" do
    follow = create(:follow)
    expect(follow).to be_valid
  end

  it "is invalid without follower_id" do
    follow = build(:follow, follower_id: nil)
    expect(follow).not_to be_valid
  end

  it "is invalid without followed_id" do
    follow = build(:follow, followed_id: nil)
    expect(follow).not_to be_valid
  end

  it "belongs to follower" do
    follow = build(:follow)
    expect(follow.follower).to be_a(User)
  end

  it "belongs to followed" do
    follow = build(:follow)
    expect(follow.followed).to be_a(User)
  end
end
