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
    year_month = YearMonth.where(year: params[:year_month][:year]).find_by(month: params[:year_month][:month])
    if year_month
      redirect_to year_month_path(year_month.id)
    else
      redirect_to year_month_path(params[:id])
    end
  end

  def manage
    @year_month = YearMonth.find(params[:id])
    @days = Day.where(year_month_id: params[:id])
    @timecards = Timecard.where(user_id: params[:user_id]).where(day_id: Day.where(year_month_id: params[:id]).ids)
    @schedules = Schedule.where(user_id: params[:user_id]).where(day_id: Day.where(year_month_id: params[:id]).ids)
  end

  def to_manage
    year_month = YearMonth.where(year: params[:year_month][:year]).find_by(month: params[:year_month][:month])
    if year_month
      redirect_to "/user/#{params[:user_id]}/year_month/#{year_month.id}"
    else
      redirect_to "/user/#{params[:user_id]}/year_month/#{params[:id]}"
    end
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

  def total
    @year_month = YearMonth.find(params[:id])
    @days = Day.where(year_month_id: params[:id])
    @users = User.all

    respond_to do |format|
      format.html
      format.xlsx do
        generate_xlsx # xlsxファイル生成用メソッド
      end
    end
  end

  private

  def year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date, days_attributes: [:date, :day_type])
  end

  def update_year_month_params
    params.require(:year_month).permit(:year, :month, :first_date, :last_date, days_attributes: [:date, :day_type, :_destroy, :id])
  end

  def generate_xlsx
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "勤怠集計") do |sheet|
        sheet.add_row ["部署" ,"氏名", "平日出勤", "休日出勤", "遅刻", "早退", "有給", "代休", "特別休暇", "欠勤"]
        @users.where.not(department: "その他").each do |u|
          @timecards = Timecard.where(user_id: u.id).where(day_id: Day.where(year_month_id: params[:id]).ids)
          @schedules = Schedule.where(user_id: u.id).where(day_id: Day.where(year_month_id: params[:id]).ids)
          shotei_total_weekday = 0
          shotei_total_houtei = 0
          shotei_total_houteigai = 0
          shoteigai_total_weekday = 0
          shoteigai_total_houtei = 0
          shoteigai_total_houteigai = 0
          overtime_total_weekday = 0
          overtime_total_houtei = 0
          overtime_total_houteigai = 0
          overtime_midnight_total_weekday = 0
          overtime_midnight_total_houtei = 0
          overtime_midnight_total_houteigai = 0
          late_total = 0
          early_total = 0
          late_count = 0
          early_count = 0
          total_break_total = 0
          total_work_total = 0
          weekday_count = 0
          holiday_count = 0
          @days.each do |d|
            timecard = d.timecards.find_by(user_id: u.id)
            schedule = d.schedules.find_by(user_id: u.id)
            shoteigai = 0
            if schedule && schedule.schedule_type.blank? || schedule.nil?
                if timecard && timecard.start && timecard.finish
                  total_work = (timecard.finish - timecard.start)
                  if timecard.break_start && timecard.break_finish
                    total_break = timecard.break_finish - timecard.break_start
                    total_work = total_work - total_break
                  end
                  if timecard.start >= Time.parse('2000-01-01 09:01')
                    late = timecard.start - Time.parse('2000-01-01 09:00')
                    late_count += 1
                    if total_work.to_i < 28800
                      shoteigai = timecard.finish - Time.parse('2000-01-01 18:00')
                    else
                      shoteigai = late
                    end
                  else
                    shoteigai = Time.parse('2000-01-01 09:00') - timecard.start
                  end
                  if timecard.finish < Time.parse('2000-01-01 18:00')
                    early = Time.parse('2000-01-01 18:00') - timecard.finish
                    early_count += 1
                  end
                  overtime = total_work - 28800
                  if timecard.finish > Time.parse('2000-01-01 22:00')
                    overtime_midnight = timecard.finish - Time.parse('2000-01-01 22:00')
                    overtime = overtime - overtime_midnight
                  end
                  shotei = total_work
                  if overtime && overtime >= 60
                    shotei = shotei - overtime
                  end
                  if overtime_midnight && overtime_midnight >= 60
                    shotei = shotei - overtime_midnight
                  end
                  if shoteigai >= 60
                    shotei = shotei - shoteigai
                  end
                  if d.day_type == "平日"
                    weekday_count += 1
                  else
                    holiday_count += 1
                  end
                end
              elsif schedule && schedule.schedule_type == "有休(PM)"
                if timecard && timecard.start && timecard.finish
                  total_work = (timecard.finish - timecard.start)
                  if timecard.break_start && timecard.break_finish
                    total_break = timecard.break_finish - timecard.break_start
                    total_work = total_work - total_break
                  end
                  if timecard.start >= Time.parse('2000-01-01 09:01')
                    late = timecard.start - Time.parse('2000-01-01 09:00')
                    late_count += 1
                  else
                    shoteigai = Time.parse('2000-01-01 09:00') - timecard.start
                  end
                  if timecard.finish < Time.parse('2000-01-01 12:00')
                    early = Time.parse('2000-01-01 12:00') - timecard.finish
                    early_count += 1
                  end
                  overtime = total_work - 28800
                  if timecard.finish > Time.parse('2000-01-01 12:00')
                    shoteigai += timecard.finish - Time.parse('2000-01-01 12:00')
                  end
                  shotei = total_work
                  if overtime && overtime >= 60
                    shotei = shotei - overtime
                  end
                  if overtime_midnight && overtime_midnight >= 60
                    shotei = shotei - overtime_midnight
                  end
                  if shoteigai >= 60
                    shotei = shotei - shoteigai
                  end
                  if d.day_type == "平日"
                    weekday_count += 1
                  else
                    holiday_count += 1
                  end
                end
              elsif schedule && schedule.schedule_type == "有休(AM)"
                if timecard && timecard.start && timecard.finish
                  total_work = (timecard.finish - timecard.start)
                  if timecard.break_start && timecard.break_finish
                    total_break = timecard.break_finish - timecard.break_start
                    total_work = total_work - total_break
                  end
                  if timecard.start >= Time.parse('2000-01-01 13:01')
                    late = timecard.start - Time.parse('2000-01-01 13:00')
                    late_count += 1
                  else
                    shoteigai = Time.parse('2000-01-01 13:00') - timecard.start
                  end
                  if timecard.finish < Time.parse('2000-01-01 18:00')
                    early = Time.parse('2000-01-01 18:00') - timecard.finish
                    early_count += 1
                  end
                  overtime = total_work - 28800
                  if timecard.finish > Time.parse('2000-01-01 18:00')
                    shoteigai += timecard.finish - Time.parse('2000-01-01 18:00')
                  end
                  shotei = total_work
                  if overtime && overtime >= 60
                    shotei = shotei - overtime
                  end
                  if overtime_midnight && overtime_midnight >= 60
                    shotei = shotei - overtime_midnight
                  end
                  if shoteigai >= 60
                    shotei = shotei - shoteigai
                  end
                  if d.day_type == "平日"
                    weekday_count += 1
                  else
                    holiday_count += 1
                  end
                end
              end
            if shotei && shotei >= 60
              if d.day_type == "平日"
                shotei_total_weekday += shotei
              elsif d.day_type == "法定休日"
                shotei_total_houtei += shotei
              elsif d.day_type == "法定外休日"
                shotei_total_houteigai += shotei
              end
            end
            if shoteigai && shoteigai >= 60
              if d.day_type == "平日"
                shoteigai_total_weekday += shoteigai
              elsif d.day_type == "法定休日"
                shoteigai_total_houtei += shoteigai
              elsif d.day_type == "法定外休日"
                shoteigai_total_houteigai += shoteigai
              end
            end
            if overtime && overtime >= 60
              if d.day_type == "平日"
                overtime_total_weekday += overtime
              elsif d.day_type == "法定休日"
                overtime_total_houtei += overtime
              elsif d.day_type == "法定外休日"
                overtime_total_houteigai += overtime
              end
            end
            if overtime_midnight && overtime_midnight >= 60
              if d.day_type == "平日"
                overtime_midnight_total_weekday += overtime_midnight
              elsif d.day_type == "法定休日"
                overtime_midnight_total_houtei += overtime_midnight
              elsif d.day_type == "法定外休日"
                overtime_midnight_total_houteigai += overtime_midnight
              end
            end
            if late && late >= 60
              late_total += late
            end
            if early
              if late == nil || late >= 60
                early_total += early
              end
            end
            if total_break && total_break >= 60
              total_break_total += total_break
            end
            if total_work && total_work >= 60
              total_work_total += total_work
            end
          end
          sheet.add_row [
            u.department,
            u.last_name + " " + u.first_name,
            weekday_count.to_f,
            holiday_count.to_f,
            late_count.to_f,
            early_count.to_f,
            @schedules.where(schedule_type: "有休").count.to_f + (@schedules.where(schedule_type: "有休(AM)").count.to_f / 2).to_f + (@schedules.where(schedule_type: "有休(PM)").count.to_f / 2).to_f,
            @schedules.where(schedule_type: "代休").count.to_f,
            @schedules.where(schedule_type: "特別休暇").count.to_f,
            @schedules.where(schedule_type: "欠勤").count.to_f
          ]
        end
      end
      p.workbook.add_worksheet(name: "通勤費") do |sheet|
        sheet.add_row ["部署", "氏名", "通勤費"]
        @users.where.not(department: "その他").each do |u|
          travel_cost_total = 0
          pass_fee = 0
          @days.each do |d|
            if d.travel_costs.find_by(user_id: u.id)
              if d.travel_costs.find_by(user_id: u.id).commute_type == "電車・バス（定期使用）"
                pass_fee = d.travel_costs.find_by(user_id: u.id).travel_cost
              else
                travel_cost_total += d.travel_costs.find_by(user_id: u.id).travel_cost
              end
            end
          end
          travel_cost_total += pass_fee
          sheet.add_row [
            u.department,
            u.last_name + " " + u.first_name,
            travel_cost_total.to_s(:delimited)
          ]
        end
      end
      send_data(p.to_stream.read,
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename: @year_month.year.to_s + "年" + @year_month.month.to_s + "月度" + " 勤怠・通勤費集計.xlsx")
    end
  end

end