class PermissionsController < ApplicationController

  def index
    @waiting_pending_timecards = PendingTimecard.where(status: "未承認")
    @waiting_pending_schedules = PendingSchedule.where(status: "未承認")
    @pending_timecards = PendingTimecard.all
    @pending_schedules = PendingSchedule.all
  end

end
