require 'rails_helper'

def sleep_tracker_attributes
  {
    user_id: FactoryBot.create(:user).id,
    slept_at: Time.now - 8.hours,
    woke_up_at: Time.now
  }
end

RSpec.describe SleepTrackersController, type: :controller do
  let!(:sleep_tracker) { FactoryBot.create(:sleep_tracker) }

  describe 'GET #index' do
    it 'returns a paginated list of sleep trackers' do
      get :index
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_trackers']).to be_an(Array)
      expect(json['current_page']).to eq(1)
      expect(json['total_pages']).to be >= 1
      expect(json['total_count']).to be >= 1
    end
  end

  describe 'GET #show' do
    it 'returns the sleep tracker' do
      get :show, params: { id: sleep_tracker.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(sleep_tracker.id)
    end
  end

  describe 'POST #create' do
    it 'creates a new sleep tracker' do
      attrs = sleep_tracker_attributes
      expect {
        post :create, params: { sleep_tracker: attrs }
      }.to change(SleepTracker, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns errors for invalid params' do
      post :create, params: { sleep_tracker: { user_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #update' do
    it 'updates the sleep tracker' do
  new_woke_up_at = Time.now
  patch :update, params: { id: sleep_tracker.id, sleep_tracker: { woke_up_at: new_woke_up_at } }
  expect(response).to have_http_status(:ok)
  expect(sleep_tracker.reload.woke_up_at.to_i).to eq(new_woke_up_at.to_i)
    end

    it 'returns errors for invalid update' do
      patch :update, params: { id: sleep_tracker.id, sleep_tracker: { user_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the sleep tracker' do
      expect {
        delete :destroy, params: { id: sleep_tracker.id }
      }.to change(SleepTracker, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
