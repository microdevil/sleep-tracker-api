require 'rails_helper'

RSpec.describe "SleepTrackers API", type: :request do
  let(:user) { create(:user) }
  let!(:sleep_trackers) { create_list(:sleep_tracker, 3, user: user) }
  let(:sleep_tracker_id) { sleep_trackers.first.id }

  describe "GET /sleep_trackers" do
    it "returns sleep trackers" do
      get "/sleep_trackers"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["sleep_trackers"].size).to eq(3)
    end
  end

  describe "GET /sleep_trackers/:id" do
    it "returns the sleep tracker" do
      get "/sleep_trackers/#{sleep_tracker_id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(sleep_tracker_id)
    end
  end

  describe "POST /sleep_trackers" do
    let(:valid_attributes) { { sleep_tracker: { user_id: user.id, slept_at: Time.now, woke_up_at: Time.now + 8.hours } } }

    it "creates a sleep tracker" do
      expect {
        post "/sleep_trackers", params: valid_attributes
      }.to change(SleepTracker, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/sleep_trackers", params: { sleep_tracker: { user_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /sleep_trackers/:id" do
    let(:new_time) { Time.now + 10.hours }
    it "updates the sleep tracker" do
      patch "/sleep_trackers/#{sleep_tracker_id}", params: { sleep_tracker: { woke_up_at: new_time } }
      expect(response).to have_http_status(:ok)
      expect(SleepTracker.find(sleep_tracker_id).woke_up_at.to_i).to eq(new_time.to_i)
    end
  end

  describe "DELETE /sleep_trackers/:id" do
    it "deletes the sleep tracker" do
      expect {
        delete "/sleep_trackers/#{sleep_tracker_id}"
      }.to change(SleepTracker, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
