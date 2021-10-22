class TimecardsController < ApplicationController

  def index
  end

  def new
    @timecard = Timecard.where(user_id: current_user.id).where(day_id: Day.find_by(date: Date.today).id)
  end

  def create_start
    timecard = Timecard.new
    timecard.start = Time.now
    timecard.user_id = current_user.id
    timecard.day_id = Day.find_by(date: Date.today).id
    timecard.save
    redirect_to new_timecard_path
  end

  def create_finish
    timecard = Timecard.new
    timecard.create_finish = Time.now
    timecard.user_id = current_user.id
    timecard.day_id = Day.find_by(date: Date.today).id
    timecard.save
    redirect_to new_timecard_path
  end

  def create_break_start
    timecard = Timecard.new
    timecard.break_start = Time.now
    timecard.user_id = current_user.id
    timecard.day_id = Day.find_by(date: Date.today).id
    timecard.save
    redirect_to new_timecard_path
  end

  def create_break_finish
    timecard = Timecard.new
    timecard.break_finish = Time.now
    timecard.user_id = current_user.id
    timecard.day_id = Day.find_by(date: Date.today).id
    timecard.save
    redirect_to new_timecard_path
  end

  def create_start
    timecards = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecards.new_record?
      timecard = Timecard.new
      timecard.start = Time.now
      timecard.user_id = current_user.id
      timecard.day_id = Day.find_by(date: Date.today).id
      timecard.save
      redirect_to new_timecard_path
    else
      timecards.update_attribute(:start, Time.now)
      redirect_to new_timecard_path
    end
  end

  def create_finish
    timecards = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecards.new_record?
      timecard = Timecard.new
      timecard.finish = Time.now
      timecard.user_id = current_user.id
      timecard.day_id = Day.find_by(date: Date.today).id
      timecard.save
      redirect_to new_timecard_path
    else
      timecards.update_attribute(:finish, Time.now)
      redirect_to new_timecard_path
    end
  end

  def create_break_start
    timecards = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecards.new_record?
      timecard = Timecard.new
      timecard.break_start = Time.now
      timecard.user_id = current_user.id
      timecard.day_id = Day.find_by(date: Date.today).id
      timecard.save
      redirect_to new_timecard_path
    else
      timecards.update_attribute(:break_start, Time.now)
      redirect_to new_timecard_path
    end
  end

  def create_break_finish
    timecards = Timecard.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if timecards.new_record?
      timecard = Timecard.new
      timecard.break_finish = Time.now
      timecard.user_id = current_user.id
      timecard.day_id = Day.find_by(date: Date.today).id
      timecard.save
      redirect_to new_timecard_path
    else
      timecards.update_attribute(:break_finish, Time.now)
      redirect_to new_timecard_path
    end
  end
  

  private
  def timecard_params
    params.require(:timecard).permit(:start, :finish, :break_start, :break_finish).merge(user_id: current_user.id, day_id: DAY.find_by(date: Date.today).id)
  end
end
