class YearMonthsController < ApplicationController

  def index
    @year_months = YearMonth.all
  end

  def new
    @year_month = YearMonth.new
  end

  def create
    @year_month = YearMonth.new
    if @year_month.update(year_month_params)
      redirect_to year_months_path
    else
      render :new
    end
  end

  private

  def year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date)
  end


end