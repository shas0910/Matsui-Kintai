class PendingSchedulesController < ApplicationController

  def new
    @day = Day.find_by(id: params[:day_id])
    @pending_schedule = PendingSchedule.new
  end

  def create
    schedule = Schedule.find_or_initialize_by(user_id: current_user.id, day_id: params[:day_id])
    if schedule.new_record?
      schedule.save
    end
    pending_schedule = PendingSchedule.new(pending_schedule_params)
    pending_schedule.schedule_id = schedule.id
    pending_schedule.status = "未承認"
    pending_schedule.save
    redirect_to new_day_pending_schedule_path(params[:day_id])
  end

  private

  def pending_schedule_params
    params.require(:pending_schedule).permit(:schedule_type, :remark, :status, :comment_request, :comment_permission)
  end

end
