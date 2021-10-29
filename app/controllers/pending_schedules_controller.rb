class PendingSchedulesController < ApplicationController

  def new
    @day = Day.find_by(id: params[:day_id])
    @schedule = Schedule.where(user_id: current_user.id).find_by(day_id: params[:day_id])
    @pending_schedule = PendingSchedule.new
  end

  def create
    if params[:pending_schedule][:schedule_type] == ""
      redirect_to new_day_pending_schedule_path(params[:day_id])
      return
    end
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

  def permission
    pending_schedule = PendingSchedule.find_by(id: params[:id])
    schedule = Schedule.find_by(id: pending_schedule.schedule_id)
    if params[:commit] == "承認"
      schedule.update_attribute(:schedule_type, pending_schedule.schedule_type)
      schedule.update_attribute(:remark, pending_schedule.remark)
      pending_schedule.update_attribute(:status, "承認")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permission_path
    elsif params[:commit] == "棄却"
      pending_schedule.update_attribute(:status, "棄却")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permission_path
    end
  end

  private

  def pending_schedule_params
    params.require(:pending_schedule).permit(:schedule_type, :remark, :status, :comment_request, :comment_permission)
  end

end
