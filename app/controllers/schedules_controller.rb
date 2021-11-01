class SchedulesController < ApplicationController

  def edit
    @day = Day.find(params[:day_id])
    @schedule = Schedule.where(day_id: params[:day_id]).find_by(user_id: params[:user_id])
    @schedule_new = Schedule.new
  end

  def update
    if params[:schedule][:schedule_type] == "" && params[:schedule][:remark] == ""
      redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule"
      return
    end
    schedule = Schedule.find_or_initialize_by(day_id: params[:day_id], user_id: params[:user_id])
    if schedule.new_record?
      schedule.schedule_type = params[:schedule][:schedule_type]
      schedule.remark = params[:schedule][:remark]
      schedule.save
    else
      schedule.update_attribute(:schedule_type, params[:schedule][:schedule_type])
      schedule.update_attribute(:remark, params[:schedule][:remark])
    end
    redirect_to "/user/#{params[:user_id]}/year_month/#{Day.find(params[:day_id]).year_month_id}"
  end

end
