class DaysController < ApplicationController
  
  def new
    @year_month = YearMonth.find_by(params[:id])
  end
end
