class DaysController < ApplicationController

  def index
    @days = Day.all
  end

  def new
    @day = Day.new
    @year_month = YearMonth.find_by(params[:id])
  end

  def create
    @day = Day.new
    @year_month = YearMonth.find_by(params[:id])
    if @day.update(year_month_params)
      redirect_to year_months_path
    else
      render :new
    end
  end

  private

  def year_month_params
    params.require(:day).permit(days_attributes: [:id, :date, :day_type, :_destroy])
  end

end
