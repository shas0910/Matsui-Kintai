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
    @waiting_pending_timecards = PendingTimecard.where(status: "未承認")
    @waiting_pending_schedules = PendingSchedule.where(status: "未承認")
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
    else
      timecard.update_attribute(:start, Time.now.change(sec: 00))
    end
    redirect_to new_timecard_path, notice: "打刻しました - 出勤"
  end

  def create_finish
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.finish = Time.now.change(sec: 00)
      timecard.save
    else
      timecard.update_attribute(:finish, Time.now.change(sec: 00))
    end
    redirect_to new_timecard_path, notice: "打刻しました - 退勤"
  end

  def create_break_start
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.break_start = Time.now.change(sec: 00)
      timecard.save
    else
      timecard.update_attribute(:break_start, Time.now.change(sec: 00))
    end
    redirect_to new_timecard_path, notice: "打刻しました - 休憩開始"
  end

  def create_break_finish
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecard.new_record?
      timecard.break_finish = Time.now.change(sec: 00)
      timecard.save
    else
      timecard.update_attribute(:break_finish, Time.now.change(sec: 00))
    end
    redirect_to new_timecard_path, notice: "打刻しました - 休憩終了"
  end
  
  def edit
    @day = Day.find(params[:day_id])
    @timecard = Timecard.where(day_id: params[:day_id]).find_by(user_id: params[:user_id])
    @timecard_new = Timecard.new
  end

  def update
    timecard = Timecard.find_or_initialize_by(day_id: params[:day_id], user_id: params[:user_id])
    if timecard.new_record?
      timecard = Timecard.new(timecard_update_params)
      timecard.save
    else
      timecard.update(timecard_update_params)
    end
    redirect_to "/user/#{params[:user_id]}/year_month/#{Day.find(params[:day_id]).year_month_id}", notice: "打刻編集を保存しました"
  end

  private

  def timecard_params
    params.require(:timecard).permit(:start, :finish, :break_start, :break_finish).merge(user_id: current_user.id, day_id: DAY.find_by(date: Date.today).id)
  end

  def timecard_update_params
    params.require(:timecard).permit(:start, :finish, :break_start, :break_finish).merge(user_id: params[:user_id], day_id: params[:day_id])
  end
end
