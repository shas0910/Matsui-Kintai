class PendingTimecardsController < ApplicationController

  def new
    @timecard = Timecard.where(user_id: current_user.id)
    @day = Day.find(1)
  end


end
