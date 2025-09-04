require 'rails_helper'

RSpec.describe 'Feeds API', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let!(:sleep_tracker) { create(:sleep_tracker, user: user) }

  before do
    sign_in user
    follower.active_relationships.create(followed_id: user.id)
    user.passive_relationships.create(follower_id: followed.id)
  end

  describe 'GET /feeds' do
    it 'returns sleep trackers for the user' do
      get feeds_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['sleep_trackers'].first['id']).to eq(sleep_tracker.id)
    end

    it 'returns sorted by duration' do
      get feeds_path, params: { sort: 'duration' }
      expect(response).to have_http_status(:ok)
    end

    it 'filters by followers' do
      get feeds_path, params: { type: 'followers' }
      expect(response).to have_http_status(:ok)
    end

    it 'filters by following' do
      get feeds_path, params: { type: 'following' }
      expect(response).to have_http_status(:ok)
    end
  end


    describe 'GET /feeds/:id' do
      it 'returns sleep trackers for a specific user' do
        get feed_path(user.id)
        expect(response).to have_http_status(:ok)
        trackers = JSON.parse(response.body)['sleep_trackers']
        expect(trackers).not_to be_empty
        expect(trackers.first['id']).to eq(sleep_tracker.id)
      end

      it 'returns not found for invalid user' do
        get feed_path(0)
        expect(response).to have_http_status(:not_found)
      end
    end
end
