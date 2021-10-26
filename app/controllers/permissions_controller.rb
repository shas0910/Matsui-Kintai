class PermissionsController < ApplicationController

  def index
    @waiting_pending_timecards = PendingTimecard.where(timecard_id: Timecard.where(user_id: User.where(approver_id: current_user.id).ids).ids).where(status: "未承認")
    @waiting_pending_schedules = PendingSchedule.where(schedule_id: Schedule.where(user_id: User.where(approver_id: current_user.id).ids).ids).where(status: "未承認")
    @pending_timecards = PendingTimecard.where(timecard_id: Timecard.where(user_id: User.where(approver_id: current_user.id).ids).ids)
    @pending_schedules = PendingSchedule.where(schedule_id: Schedule.where(user_id: User.where(approver_id: current_user.id).ids).ids)
  end

end
