class PendingTimecardsController < ApplicationController

  def new
    @pending_timecard = PendingTimecard.new
    @timecard = Timecard.where(user_id: current_user.id)
  end

  def create
    @pending_timecard = PendingTimecard.create
    if @pending_timecard.save
      redirect_to new_pending_timecard_path
    else
      render :new
    end
  end

  # private

  # def pending_timecard_params
  #   params.require(:pending_timecard).permit(:start, :finish, :break_start, :break_finish, :comment_request)
  # end

end
