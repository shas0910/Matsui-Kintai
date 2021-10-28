class SchedulesController < ApplicationController

  def edit
    @schedule = Schedule.find(params[:id])
  end

  def update

  end

end
