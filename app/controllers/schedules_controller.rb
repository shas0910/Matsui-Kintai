class SchedulesController < ApplicationController

  def edit
    @day = Day.find(params[:day_id])
    @schedule = Schedule.where(day_id: params[:day_id]).find_by(user_id: params[:user_id])
    @schedule_new = Schedule.new
  end

  def update
    paid_vacation = PaidVacation.find_by(user_id: params[:user_id])
    grant_year = User.find(params[:user_id]).grant_date.year + User.find(params[:user_id]).years_of_service
    if Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id]).nil? || Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id]).schedule_type.exclude?("有休")
      if params[:schedule][:schedule_type] == "有休"
        if paid_vacation.nil? || paid_vacation.remain < 1
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif Day.find(params[:day_id]).date >= User.find(params[:user_id]).grant_date.change(year: grant_year) && Date.today < User.find(params[:user_id]).grant_date.change(year: grant_year)
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "次の有休付与日以降の日は有休に設定できません"
          return
        elsif paid_vacation.carry >= 1
          v = paid_vacation.carry - 1
          paid_vacation.update(carry: v)
        elsif paid_vacation.carry == 0.5
          v = paid_vacation.grant - 0.5
          paid_vacation.update(carry: 0, grant: v)
        elsif paid_vacation.grant >= 1
          v = paid_vacation.grant - 1
          paid_vacation.update(grant: v)
        end
      elsif params[:schedule][:schedule_type] == "有休(AM)" || params[:schedule][:schedule_type] == "有休(PM)"
        if paid_vacation.nil? || paid_vacation.remain < 0.5
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif Day.find(params[:day_id]).date >= User.find(params[:user_id]).grant_date.change(year: grant_year) && Date.today < User.find(params[:user_id]).grant_date.change(year: grant_year)
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "次の有休付与日以降の日は有休に設定できません"
          return
        elsif paid_vacation.carry >= 0.5
          v = paid_vacation.carry - 0.5
          paid_vacation.update(carry: v)
        elsif paid_vacation.grant >= 0.5
          v = paid_vacation.grant - 0.5
          paid_vacation.update(grant: v)
        end
      end
    elsif Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id]).schedule_type == "有休"
      if params[:schedule][:schedule_type] == "有休(AM)" || params[:schedule][:schedule_type] == "有休(PM)"
        if paid_vacation.grant <= User.find(params[:user_id]).grant_limit - 0.5
          v = paid_vacation.grant + 0.5
          paid_vacation.update(grant: v)
        else
          v = paid_vacation.carry + 0.5
          paid_vacation.update(carry: v)
        end
      elsif params[:schedule][:schedule_type].exclude?("有休")
        if paid_vacation.grant <= User.find(params[:user_id]).grant_limit - 1
          v = paid_vacation.grant + 1
          paid_vacation.update(grant: v)
        elsif paid_vacation.grant == User.find(params[:user_id]).grant_limit - 0.5
          v = paid_vacation.grant + 0.5
          paid_vacation.update(grant: v, carry: 0.5)
        else
          v = paid_vacation.carry + 1
          paid_vacation.update(carry: v)
        end
      end
    elsif Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id]).schedule_type == "有休(AM)" || Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id]).schedule_type == "有休(PM)"
      if params[:schedule][:schedule_type] == "有休"
        if paid_vacation.remain < 0.5
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif paid_vacation.carry >= 0.5
          v = paid_vacation.carry - 0.5
          paid_vacation.update(carry: v)
        elsif paid_vacation.grant >= 0.5
          v = paid_vacation.grant - 0.5
          paid_vacation.update(grant: v)
        end
      elsif params[:schedule][:schedule_type].exclude?("有休")
        if paid_vacation.grant <= User.find(params[:user_id]).grant_limit - 0.5
          v = paid_vacation.grant + 0.5
          paid_vacation.update(grant: v)
        else
          v = paid_vacation.carry + 0.5
          paid_vacation.update(carry: v)
        end
      end
    end
    schedule = Schedule.find_or_initialize_by(day_id: params[:day_id], user_id: params[:user_id])
    if schedule.new_record?
      schedule.schedule_type = params[:schedule][:schedule_type]
      schedule.save
    else
      schedule.update_attribute(:schedule_type, params[:schedule][:schedule_type])
    end
    redirect_to "/user/#{params[:user_id]}/year_month/#{Day.find(params[:day_id]).year_month_id}", notice: "日程編集を保存しました"
  end

end
