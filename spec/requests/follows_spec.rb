require 'rails_helper'

describe FollowsController, type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    # Simulate authentication, replace with your auth logic if needed
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'POST /users/:user_id/follow' do
    it 'follows another user' do
      post "/users/#{other_user.id}/follow"
      expect(response).to have_http_status(:created)
  expect(user.followings).to include(other_user)
    end

    it 'does not follow if already following' do
      user.active_relationships.create(followed: other_user)
      post "/users/#{other_user.id}/follow"
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /users/:user_id/unfollow' do
    it 'unfollows a user' do
      user.active_relationships.create(followed: other_user)
      delete "/users/#{other_user.id}/unfollow"
      expect(response).to have_http_status(:ok)
  expect(user.followings).not_to include(other_user)
    end

    it 'does not unfollow if not following' do
      delete "/users/#{other_user.id}/unfollow"
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
