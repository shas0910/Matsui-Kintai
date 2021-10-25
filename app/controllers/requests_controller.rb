class RequestsController < ApplicationController

  def index
    @pending_timecards = PendingTimecard.where(id: Timecard.where(user_id: current_user.id).ids)
    @pending_schedules = PendingSchedule.where(id: Schedule.where(user_id: current_user.id).ids)
  end

end
