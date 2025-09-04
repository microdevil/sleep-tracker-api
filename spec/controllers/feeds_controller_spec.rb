require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:user) { create(:user) }
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let!(:sleep_tracker) { create(:sleep_tracker, user: user) }

  before do
    sign_in user
    follower.active_relationships.create(followed_id: user.id)
    user.passive_relationships.create(follower_id: followed.id)
  end

  describe 'GET #index' do
    it 'returns sleep trackers for the user' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['sleep_trackers'].first['id']).to eq(sleep_tracker.id)
    end

    it 'sorts by duration when requested' do
      get :index, params: { sort: 'duration' }
      expect(response).to have_http_status(:ok)
    end

    it 'filters by followers' do
      get :index, params: { type: 'followers' }
      expect(response).to have_http_status(:ok)
    end

    it 'filters by following' do
      get :index, params: { type: 'following' }
      expect(response).to have_http_status(:ok)
    end
  end
end
