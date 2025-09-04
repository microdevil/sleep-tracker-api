
class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    trackers = SleepTracker
                 .joins(:user)
                 .merge(filter_relation)

    trackers =
      case params[:sort]
      when "duration"
        trackers.order("sleep_trackers.duration DESC")
      else
        trackers.order("sleep_trackers.slept_at DESC")
      end

    trackers = trackers.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      sleep_trackers: trackers.as_json(
        only: [ :id, :slept_at, :woke_up_at, :duration ],
        include: { user: { only: [ :id, :name, :email ] } }
      ),
      meta: {
        current_page: trackers.current_page,
        next_page: trackers.next_page,
        prev_page: trackers.prev_page,
        total_pages: trackers.total_pages,
        total_count: trackers.total_count
      }
    }
  end

  # Show sleep trackers for a specific user
  def show
    user = User.find_by(id: params[:id])
    unless user
      render json: { error: "User not found" }, status: :not_found and return
    end

    trackers = user.sleep_trackers.order(slept_at: :desc).page(params[:page]).per(params[:per_page] || 10)

    render json: {
      sleep_trackers: trackers.as_json(
        only: [ :id, :slept_at, :woke_up_at, :duration ],
        include: { user: { only: [ :id, :name, :email ] } }
      ),
      meta: {
        current_page: trackers.current_page,
        next_page: trackers.next_page,
        prev_page: trackers.prev_page,
        total_pages: trackers.total_pages,
        total_count: trackers.total_count
      }
    }
  end

  private

  def filter_relation
    case params[:type]
    when "followers"
      User.joins(:active_relationships).where(follows: { followed_id: current_user.id })
    when "following"
      User.joins(:passive_relationships).where(follows: { follower_id: current_user.id })
    else
      ids = [ current_user.id ]
      ids += User.joins(:active_relationships).where(follows: { followed_id: current_user.id }).pluck(:id)
      ids += User.joins(:passive_relationships).where(follows: { follower_id: current_user.id }).pluck(:id)
      User.where(id: ids.uniq)
    end
  end
end
