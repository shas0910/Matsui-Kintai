class SchedulesController < ApplicationController

  def edit
    @day = Day.find(params[:day_id])
    @schedule = Schedule.where(day_id: params[:day_id]).find_by(user_id: params[:user_id])
    @schedule_new = Schedule.new
  end

  def update
    user = User.find(params[:user_id])
    day = Day.find(params[:day_id])
    schedule = Schedule.find_by(day_id: params[:day_id], user_id: params[:user_id])
    paid_vacation = PaidVacation.where(user_id: params[:user_id])
    oldest_paid_vacation = PaidVacation.find_by(granted_date: paid_vacation.minimum(:granted_date))
    second_oldest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :ASC).to_a[1].id)
    third_oldest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :ASC).to_a[2].id)
    newest_paid_vacation = PaidVacation.find_by(granted_date: paid_vacation.maximum(:granted_date))
    second_newest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :DESC).to_a[1].id)
    third_newest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :DESC).to_a[2].id)
    grant_year = user.grant_date.year + user.years_of_service
    if schedule.nil? || schedule.schedule_type.exclude?("有休")
      if params[:schedule][:schedule_type] == "有休"
        if paid_vacation.nil? || user.remain_total < 1
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif day.date >= user.grant_date.change(year: grant_year) && Date.today < user.grant_date.change(year: grant_year)
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "次の有休付与日以降の日は有休に設定できません"
          return
        elsif oldest_paid_vacation.remain >= 1
          v = oldest_paid_vacation.remain - 1
          oldest_paid_vacation.update(remain: v)
        elsif oldest_paid_vacation.remain == 0.5
          oldest_paid_vacation.update(remain: 0)
          v = second_oldest_paid_vacation.remain - 0.5
          second_oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain >= 1
          v = second_oldest_paid_vacation.remain - 1
          second_oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain == 0.5
          second_oldest_paid_vacation.update(remain: 0)
          v = third_oldest_paid_vacation.remain - 0.5
          third_oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain == 0
          v = third_oldest_paid_vacation.remain - 1
          third_oldest_paid_vacation.update(remain: v)
        end
      elsif params[:schedule][:schedule_type] == "有休(AM)" || params[:schedule][:schedule_type] == "有休(PM)"
        if paid_vacation.nil? || user.remain_total < 0.5
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif day.date >= user.grant_date.change(year: grant_year) && Date.today < user.grant_date.change(year: grant_year)
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "次の有休付与日以降の日は有休に設定できません"
          return
        elsif oldest_paid_vacation.remain >= 0.5
          v = oldest_paid_vacation.remain - 0.5
          oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain >= 0.5
          v = second_oldest_paid_vacation.remain - 0.5
          second_oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain == 0
          v = third_oldest_paid_vacation.remain - 0.5
          third_oldest_paid_vacation.update(remain: v)
        end
      end
    elsif schedule.schedule_type == "有休"
      if params[:schedule][:schedule_type] == "有休(AM)" || params[:schedule][:schedule_type] == "有休(PM)"
        if newest_paid_vacation.remain <= newest_paid_vacation.remain_limit - 0.5
          v = newest_paid_vacation.remain + 0.5
          newest_paid_vacation.update(remain: v)
        elsif second_newest_paid_vacation.remain <= second_oldest_paid_vacation.remain_limit - 0.5
          v = second_newest_paid_vacation.remain + 0.5
          second_newest_paid_vacation.update(remain: v)
        elsif second_newest_paid_vacation.remain > second_oldest_paid_vacation.remain_limit - 0.5
          v = third_newest_paid_vacation.remain + 0.5
          third_newest_paid_vacation.update(remain: v)
        end
      elsif params[:schedule][:schedule_type].exclude?("有休")
        if newest_paid_vacation.remain <= newest_paid_vacation.remain_limit - 1
          v = newest_paid_vacation.remain + 1
          newest_paid_vacation.update(remain: v)
        elsif newest_paid_vacation.remain == newest_paid_vacation.remain_limit - 0.5
          newest_paid_vacation.update(remain: newest_paid_vacation.remain_limit)
          second_newest_paid_vacation.update(remain: 0.5)
        elsif second_newest_paid_vacation.remain <= second_newest_paid_vacation.remain_limit - 1
          v = second_newest_paid_vacation.remain + 1
          second_newest_paid_vacation.update(remain: v)
        elsif second_newest_paid_vacation.remain == second_newest_paid_vacation.remain_limit - 0.5
          second_newest_paid_vacation.update(remain:  second_newest_paid_vacation.remain_limit)
          third_newest_paid_vacation.update(remain: 0.5)
        else
          v = third_newest_paid_vacation.remain + 1
          third_newest_paid_vacation.update(remain: v)
        end
      end
    elsif schedule.schedule_type == "有休(AM)" || schedule.schedule_type == "有休(PM)"
      if params[:schedule][:schedule_type] == "有休"
        if user.remain_total < 0.5
          redirect_to "/user/#{params[:user_id]}/day/#{params[:day_id]}/edit_schedule", alert: "有休残日数が不足しています"
          return
        elsif oldest_paid_vacation.remain >= 0.5
          v = oldest_paid_vacation.remain - 0.5
          oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain >= 0.5
          v = second_oldest_paid_vacation.remain - 0.5
          second_oldest_paid_vacation.update(remain: v)
        elsif second_oldest_paid_vacation.remain == 0
          v = third_oldest_paid_vacation.remain - 0.5
          third_oldest_paid_vacation.update(remain: v)
        end
      elsif params[:schedule][:schedule_type].exclude?("有休")
        if newest_paid_vacation.remain <= newest_paid_vacation.remain_limit - 0.5
          v = newest_paid_vacation.remain + 0.5
          newest_paid_vacation.update(remain: v)
        elsif second_newest_paid_vacation.remain <= second_oldest_paid_vacation.remain_limit - 0.5
          v = second_newest_paid_vacation.remain + 0.5
          second_newest_paid_vacation.update(remain: v)
        elsif second_newest_paid_vacation.remain > second_oldest_paid_vacation.remain_limit - 0.5
          v = third_newest_paid_vacation.remain + 0.5
          third_newest_paid_vacation.update(remain: v)
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
