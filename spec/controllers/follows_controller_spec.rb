require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:jwt_token) do
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end

  before do
    request.headers['Authorization'] = "Bearer #{jwt_token}"
  end

  describe 'POST #create' do
    context 'when not already following' do
      it 'creates a follow relationship and returns success' do
        post :create, params: { user_id: other_user.id }
        expect(user.followings).to include(other_user)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['success']).to eq('Followed user')
      end
    end

    context 'when already following' do
  before { user.active_relationships.create(followed: other_user) }

      it 'returns error' do
        post :create, params: { user_id: other_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Already following')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when following' do
      before { user.active_relationships.create(followed: other_user) }

      it 'destroys the relationship and returns success' do
        delete :destroy, params: { user_id: other_user.id }
        expect(user.followings).not_to include(other_user)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to eq('Unfollowed user')
      end
    end

    context 'when not following' do
      it 'returns error' do
        delete :destroy, params: { user_id: other_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Not following')
      end
    end
  end
end
