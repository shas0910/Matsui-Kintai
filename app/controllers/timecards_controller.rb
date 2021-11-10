class TimecardsController < ApplicationController

  def index
    @users = User.where.not(user_type: "管理者")
    @days = Day.where(date: ...Date.today)
  end

  def new
    @timecard = Timecard.where(user_id: current_user.id).where(day_id: Day.find_by(date: Date.today).id)
    @days = Day.where(date: ...Date.today)
    @pending_timecards = PendingTimecard.where(updated_at: 1.day.ago..).where(timecard_id: Timecard.where(user_id: current_user.id).ids)
    @pending_schedules = PendingSchedule.where(updated_at: 1.day.ago..).where(schedule_id: Schedule.where(user_id: current_user.id).ids)
    @pending_timecards_member = PendingTimecard.where(timecard_id: Timecard.where(user_id: User.where(approver_id: current_user.id).ids).ids).where(status: "未承認")
    @pending_schedules_member = PendingSchedule.where(schedule_id: Schedule.where(user_id: User.where(approver_id: current_user.id).ids).ids).where(status: "未承認")
    @members = User.where(approver_id: current_user.id)
    @users = User.where.not(user_type: "管理者")
  end

  def create_start
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.start = Time.now.change(sec: 00)
      timecard.save
      redirect_to new_timecard_path
    else
      timecard.update_attribute(:start, Time.now.change(sec: 00))
      redirect_to new_timecard_path
    end
  end

  def create_finish
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.finish = Time.now.change(sec: 00)
      timecard.save
      redirect_to new_timecard_path
    else
      timecard.update_attribute(:finish, Time.now.change(sec: 00))
      redirect_to new_timecard_path
    end
  end

  def create_break_start
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.break_start = Time.now.change(sec: 00)
      timecard.save
      redirect_to new_timecard_path
    else
      timecard.update_attribute(:break_start, Time.now.change(sec: 00))
      redirect_to new_timecard_path
    end
  end

  def create_break_finish
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.break_finish = Time.now.change(sec: 00)
      timecard.save
      redirect_to new_timecard_path
    else
      timecard.update_attribute(:break_finish, Time.now.change(sec: 00))
      redirect_to new_timecard_path
    end
  end
  
  def edit
    @day = Day.find(params[:day_id])
    @timecard = Timecard.where(day_id: params[:day_id]).find_by(user_id: params[:user_id])
    @timecard_new = Timecard.new
  end

  def update
    if params[:timecard][:timecard_type] == ""
      redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_timecard"
      return
    end
    timecard = Timecard.find_or_initialize_by(day_id: params[:day_id], user_id: params[:user_id])
    if timecard.new_record?
      if params[:timecard][:timecard_type] = "出勤"
        timecard.start = params[:timecard][:timecard_time]
      elsif params[:timecard][:timecard_type] = "退勤"
        timecard.finish = params[:timecard][:timecard_time]
      elsif params[:timecard][:timecard_type] = "休憩開始"
        timecard.break_start = params[:timecard][:timecard_time]
      elsif params[:timecard][:timecard_type] = "休憩終了"
        timecard.break_finish = params[:timecard][:timecard_time]
      end
      timecard.save
    elsif params[:timecard][:timecard_type] = "出勤"
      timecard.update_attribute(:start, params[:timecard][:timecard_time])
    elsif params[:timecard][:timecard_type] = "退勤"
      timecard.update_attribute(:finish, params[:timecard][:timecard_time])
    elsif params[:timecard][:timecard_type] = "休憩開始"
      timecard.update_attribute(:break_start, params[:timecard][:timecard_time])
    elsif params[:timecard][:timecard_type] = "休憩終了"
      timecard.update_attribute(:break_finish, params[:timecard][:timecard_time])
    end
    redirect_to "/user/#{params[:user_id]}/year_month/#{Day.find(params[:day_id]).year_month_id}"
  end

  private
  def timecard_params
    params.require(:timecard).permit(:start, :finish, :break_start, :break_finish).merge(user_id: current_user.id, day_id: DAY.find_by(date: Date.today).id)
  end
end
