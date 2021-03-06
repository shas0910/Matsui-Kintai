class PendingSchedulesController < ApplicationController

  def new
    @day = Day.find_by(id: params[:day_id])
    @schedule = Schedule.where(user_id: current_user.id).find_by(day_id: params[:day_id])
    @pending_schedule = PendingSchedule.new
  end

  def create
    schedule = Schedule.find_or_initialize_by(user_id: current_user.id, day_id: params[:day_id])
    if schedule.new_record?
      schedule.save
    end
    pending_schedule = PendingSchedule.find_or_initialize_by(schedule_id: schedule.id, status: "未承認")
    if pending_schedule.new_record?
      pending_schedule = PendingSchedule.new(pending_schedule_params)
      pending_schedule.schedule_id = schedule.id
      pending_schedule.status = "未承認"
      pending_schedule.save
    else
      pending_schedule.update(pending_schedule_params)
    end
    redirect_to "/year_months/#{Day.find(params[:day_id]).year_month_id}", notice: "日程申請しました"
  end

  def destroy
    pending_schedule = PendingSchedule.find(params[:id])
    pending_schedule.destroy
    redirect_to requests_path, notice: "日程申請をキャンセルしました"
  end
  
  def permission
    pending_schedule = PendingSchedule.find_by(id: params[:id])
    schedule = Schedule.find_by(id: pending_schedule.schedule_id)
    if params[:commit] == "承認"
      schedule.update_attribute(:schedule_type, pending_schedule.schedule_type)
      pending_schedule.update_attribute(:status, "承認")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permissions_path, notice: "日程申請を承認しました"
    elsif params[:commit] == "棄却"
      pending_schedule.update_attribute(:status, "棄却")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permissions_path, notice: "日程申請を棄却しました"
    end
  end

  private

  def pending_schedule_params
    params.require(:pending_schedule).permit(:schedule_type, :status, :comment_request, :comment_permission)
  end

end
