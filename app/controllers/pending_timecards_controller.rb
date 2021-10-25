class PendingTimecardsController < ApplicationController

  def new
    @pending_timecard = PendingTimecard.new
    @timecard = Timecard.where(user_id: current_user.id)
    @day = Day.find(params[:day_id])
  end

  def create
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: params[:day_id])
    if timecard.new_record?
      timecard.save
    end
    pending_timecard = PendingTimecard.new(pending_timecard_params)
    pending_timecard.timecard_id = timecard.id
    pending_timecard.status = "未承認"
    pending_timecard.save
    redirect_to new_day_pending_timecard_path(params[:day_id])
  end

  private

  def pending_timecard_params
    params.require(:pending_timecard).permit(:timecard_type, :pending_time, :comment_request)
  end

end
