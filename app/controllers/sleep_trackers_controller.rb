class SleepTrackersController < ApplicationController
  # GET /sleep_trackers
  def index
    @sleep_trackers = SleepTracker.page(params[:page]).per(params[:per_page] || 25)
    render json: {
      sleep_trackers: @sleep_trackers,
      current_page: @sleep_trackers.current_page,
      total_pages: @sleep_trackers.total_pages,
      total_count: @sleep_trackers.total_count
    }
  end

  # GET /sleep_trackers/:id
  def show
    @sleep_tracker = SleepTracker.find(params[:id])
    render json: @sleep_tracker
  end

  # POST /sleep_trackers
  def create
    @sleep_tracker = SleepTracker.new(sleep_tracker_params)
    if @sleep_tracker.save
      render json: @sleep_tracker, status: :created
    else
      render json: @sleep_tracker.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sleep_trackers/:id
  def update
    @sleep_tracker = SleepTracker.find(params[:id])
    if @sleep_tracker.update(sleep_tracker_params)
      render json: @sleep_tracker
    else
      render json: @sleep_tracker.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sleep_trackers/:id
  def destroy
    @sleep_tracker = SleepTracker.find(params[:id])
    @sleep_tracker.destroy
    head :no_content
  end

  private

  def sleep_tracker_params
    params.require(:sleep_tracker).permit(:user_id, :slept_at, :woke_up_at, :duration)
  end
end
