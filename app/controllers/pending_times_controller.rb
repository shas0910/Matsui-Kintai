class PendingTimesController < ApplicationController

  def new
    @timecard = Timecard.where(user_id: current_user.id)
    @day = Day.all
  end
end
