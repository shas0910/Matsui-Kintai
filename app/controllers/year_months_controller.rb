class YearMonthsController < ApplicationController

  def new
    @year_month = YearMonth.new
  end

  def create
    @year_month = YearMonth.new(year_month_params)
      unless @year_month.valid?
        render :new and return
      end
    session["year_month"] = {year_month: @year_month.attributes}
    @day = @year_month.days.build
    render :new_days
  end

  private

  def year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date)
  end

end