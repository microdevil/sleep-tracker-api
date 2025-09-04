class FollowsController < ApplicationController
  before_action :set_user

  # POST /users/:user_id/follow
  def create
    if current_user.followings.include?(@user)
      render json: { error: "Already following" }, status: :unprocessable_entity
    else
      current_user.active_relationships.create(followed: @user)
      render json: { success: "Followed user" }, status: :created
    end
  end

  # DELETE /users/:user_id/unfollow
  def destroy
    relationship = current_user.active_relationships.find_by(followed: @user)
    if relationship
      relationship.destroy
      render json: { success: "Unfollowed user" }, status: :ok
    else
      render json: { error: "Not following" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
