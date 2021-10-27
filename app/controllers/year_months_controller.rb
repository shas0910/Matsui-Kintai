class YearMonthsController < ApplicationController

  def index
    @year_months = YearMonth.all
  end

  def show
    @year_month = YearMonth.find(params[:id])
    @days = Day.where(year_month_id: params[:id])
    @timecards = Timecard.where(user_id: current_user.id).where(day_id: Day.where(year_month_id: params[:id]).ids)
    @schedules = Schedule.where(user_id: current_user.id).where(day_id: Day.where(year_month_id: params[:id]).ids)
  end

  def to_show
    year_month = YearMonth.where(year: params[:year_month][:year]).where(month: params[:year_month][:month])
    if year_month.exists?
      redirect_to year_month_path(year_month.ids)
    else
      redirect_to year_month_path(Day.find_by(date: Date.today).year_month_id)
    end
  end

  def manage
    @year_month = YearMonth.find(params[:id])
    @days = Day.where(year_month_id: params[:id])
    @timecards = Timecard.where(user_id: params[:user_id]).where(day_id: Day.where(year_month_id: params[:id]).ids)
    @schedules = Schedule.where(user_id: params[:user_id]).where(day_id: Day.where(year_month_id: params[:id]).ids)
  end

  def new
    @year_month = YearMonth.new
    @year_month.days.build
  end

  def create
    YearMonth.create(year_month_params)
    redirect_to year_months_path
  end

  def edit
    @year_month = YearMonth.find(params[:id])
  end

  def update
    @year_month = YearMonth.find(params[:id])
    if @year_month.update(update_year_month_params)
      redirect_to year_months_path
    else
      render :edit
    end
  end

  def destroy
    YearMonth.find(params[:id]).destroy
    redirect_to year_months_path
  end

  private

  def year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date, days_attributes: [:date, :day_type])
  end

  def update_year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date, days_attributes: [:date, :day_type, :_destroy, :id])
  end

end