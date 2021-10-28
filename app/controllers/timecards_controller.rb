class TimecardsController < ApplicationController

  def index
  end

  def new
    @timecard = Timecard.where(user_id: current_user.id).where(day_id: Day.find_by(date: Date.today).id)
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
    @timecard = Timecard.find(params[:id])
  end

  def update
    
  end

  private
  def timecard_params
    params.require(:timecard).permit(:start, :finish, :break_start, :break_finish).merge(user_id: current_user.id, day_id: DAY.find_by(date: Date.today).id)
  end
end
