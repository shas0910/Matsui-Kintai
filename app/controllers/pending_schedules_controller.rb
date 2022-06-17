class PendingSchedulesController < ApplicationController

  def new
    @day = Day.find_by(id: params[:day_id])
    @schedule = Schedule.where(user_id: current_user.id).find_by(day_id: params[:day_id])
    @pending_schedule = PendingSchedule.new
  end

  def create
    schedule = Schedule.find_or_initialize_by(user_id: current_user.id, day_id: params[:day_id])
    if schedule.new_record?
      schedule.save
    end
    pending_schedule = PendingSchedule.find_or_initialize_by(schedule_id: schedule.id, status: "未承認")
    if pending_schedule.new_record?
      pending_schedule = PendingSchedule.new(pending_schedule_params)
      pending_schedule.schedule_id = schedule.id
      pending_schedule.status = "未承認"
      pending_schedule.save
    else
      pending_schedule.update(pending_schedule_params)
    end
    redirect_to "/year_months/#{Day.find(params[:day_id]).year_month_id}", notice: "日程申請しました"
  end

  def destroy
    pending_schedule = PendingSchedule.find(params[:id])
    pending_schedule.destroy
    redirect_to requests_path, notice: "日程申請をキャンセルしました"
  end
  
  def permission
    
    pending_schedule = PendingSchedule.find_by(id: params[:id])
    schedule = Schedule.find_by(id: pending_schedule.schedule_id)
    user = User.find(schedule.user_id)
    paid_vacation = PaidVacation.where(user_id: user.id)
    oldest_paid_vacation = PaidVacation.find_by(granted_date: paid_vacation.minimum(:granted_date))
    second_oldest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :ASC).to_a[1].id)
    third_oldest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :ASC).to_a[2].id)
    newest_paid_vacation = PaidVacation.find_by(granted_date: paid_vacation.maximum(:granted_date))
    second_newest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :DESC).to_a[1].id)
    third_newest_paid_vacation = PaidVacation.find(paid_vacation.order(granted_date: :DESC).to_a[2].id)
    grant_year = user.grant_date.year + user.years_of_service
    if params[:commit] == "承認"
      if schedule.schedule_type.nil? || schedule.schedule_type.exclude?("有休")
        if pending_schedule.schedule_type == "有休"
          if paid_vacation.nil? || user.remain_total < 1
            redirect_to permissions_path, alert: "有休残日数が不足しています"
            return
          elsif day.date >= user.grant_date.change(year: grant_year) && Date.today < user.grant_date.change(year: grant_year)
            redirect_to permissions_path, alert: "次の有休付与日以降の日は有休に設定できません"
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
        elsif pending_schedule.schedule_type == "有休(AM)" || pending_schedule.schedule_type == "有休(PM)"
          if paid_vacation.nil? || user.remain_total < 0.5
            redirect_to permissions_path, alert: "有休残日数が不足しています"
            return
          elsif day.date >= user.grant_date.change(year: grant_year) && Date.today < user.grant_date.change(year: grant_year)
            redirect_to permissions_path, alert: "次の有休付与日以降の日は有休に設定できません"
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
        if pending_schedule.schedule_type == "有休(AM)" || pending_schedule.schedule_type == "有休(PM)"
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
        elsif pending_schedule.schedule_type.exclude?("有休")
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
        if pending_schedule.schedule_type == "有休"
          if user.remain_total < 0.5
            redirect_to permissions_path, alert: "有休残日数が不足しています"
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
        elsif pending_schedule.schedule_type.exclude?("有休")
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
      schedule.update_attribute(:schedule_type, pending_schedule.schedule_type)
      pending_schedule.update_attribute(:status, "承認")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permissions_path, notice: "日程申請を承認しました"
    elsif params[:commit] == "棄却"
      pending_schedule.update_attribute(:status, "棄却")
      pending_schedule.update_attribute(:comment_permission, params[:pending_schedule][:comment_permission])
      redirect_to permissions_path, notice: "日程申請を棄却しました"
    end
  end

  private

  def pending_schedule_params
    params.require(:pending_schedule).permit(:schedule_type, :status, :comment_request, :comment_permission)
  end

end
