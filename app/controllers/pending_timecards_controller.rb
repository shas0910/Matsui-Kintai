class PendingTimecardsController < ApplicationController

  def new
    @pending_timecard = PendingTimecard.new
    @timecard = Timecard.where(user_id: current_user.id).find_by(day_id: params[:day_id])
    @day = Day.find(params[:day_id])
  end

  def create
    if params[:pending_timecard][:timecard_type] == ""
      redirect_to new_day_pending_timecard_path(params[:day_id]), alert: "打刻種別を入力してください"
      return
    end
    timecard = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: params[:day_id])
    if timecard.new_record?
      timecard.save
    end
    if params[:pending_timecard][:timecard_type] == "出勤"
      pending_timecard = PendingTimecard.find_or_initialize_by(timecard_id: timecard.id, timecard_type: "出勤", status: "未承認")
      if pending_timecard.new_record?
        pending_timecard = PendingTimecard.new(pending_timecard_params)
        pending_timecard.timecard_id = timecard.id
        pending_timecard.timecard_type = "出勤"
        pending_timecard.status = "未承認"
        pending_timecard.save
      else
        pending_timecard.update(pending_timecard_params)
      end
    elsif params[:pending_timecard][:timecard_type] == "退勤"
      pending_timecard = PendingTimecard.find_or_initialize_by(timecard_id: timecard.id, timecard_type: "退勤", status: "未承認")
      if pending_timecard.new_record?
        pending_timecard = PendingTimecard.new(pending_timecard_params)
        pending_timecard.timecard_id = timecard.id
        pending_timecard.timecard_type = "退勤"
        pending_timecard.status = "未承認"
        pending_timecard.save
      else
        pending_timecard.update(pending_timecard_params)
      end
    elsif params[:pending_timecard][:timecard_type] == "休憩開始"
      pending_timecard = PendingTimecard.find_or_initialize_by(timecard_id: timecard.id, timecard_type: "休憩開始", status: "未承認")
      if pending_timecard.new_record?
        pending_timecard = PendingTimecard.new(pending_timecard_params)
        pending_timecard.timecard_id = timecard.id
        pending_timecard.timecard_type = "休憩開始"
        pending_timecard.status = "未承認"
        pending_timecard.save
      else
        pending_timecard.update(pending_timecard_params)
      end
    elsif params[:pending_timecard][:timecard_type] == "休憩終了"
      pending_timecard = PendingTimecard.find_or_initialize_by(timecard_id: timecard.id, timecard_type: "休憩終了", status: "未承認")
      if pending_timecard.new_record?
        pending_timecard = PendingTimecard.new(pending_timecard_params)
        pending_timecard.timecard_id = timecard.id
        pending_timecard.timecard_type = "休憩終了"
        pending_timecard.status = "未承認"
        pending_timecard.save
      else
        pending_timecard.update(pending_timecard_params)
      end
    end
    redirect_to "/year_months/#{Day.find(params[:day_id]).year_month_id}", notice: "打刻申請しました"
  end

  def destroy
    pending_timecard = PendingTimecard.find(params[:id])
    pending_timecard.destroy
    redirect_to requests_path, notice: "打刻申請をキャンセルしました"
  end
  
  def permission
    pending_timecard = PendingTimecard.find_by(id: params[:id])
    timecard = Timecard.find_by(id: pending_timecard.timecard_id)
    if params[:commit] == "承認"
      if pending_timecard.timecard_type == "出勤"
        timecard.update_attribute(:start, pending_timecard.pending_time)
      elsif pending_timecard.timecard_type == "退勤"
        timecard.update_attribute(:finish, pending_timecard.pending_time)
      elsif pending_timecard.timecard_type == "休憩開始"
        timecard.update_attribute(:break_start, pending_timecard.pending_time)
      elsif pending_timecard.timecard_type == "休憩終了"
        timecard.update_attribute(:break_finish, pending_timecard.pending_time)
      end
      pending_timecard.update_attribute(:status, "承認")
      pending_timecard.update_attribute(:comment_permission, params[:pending_timecard][:comment_permission])
      redirect_to permissions_path, notice: "打刻申請を承認しました"
    elsif params[:commit] == "棄却"
      pending_timecard.update_attribute(:status, "棄却")
      pending_timecard.update_attribute(:comment_permission, params[:pending_timecard][:comment_permission])
      redirect_to permissions_path, notice: "打刻申請を棄却しました"
    end
  end

  private

  def pending_timecard_params
    params.require(:pending_timecard).permit(:timecard_type, :pending_time, :comment_request)
  end

end
