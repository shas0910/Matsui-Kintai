class YearMonthsController < ApplicationController

  def new
    @year_month = YearMonth.new
  end

  def create
    YearMonth.create(year_month_params)
  end

  private

  def year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date)
  end

end