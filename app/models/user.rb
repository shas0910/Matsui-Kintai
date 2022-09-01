class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :timecards, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_one :commute, dependent: :destroy
  has_many :travel_costs, dependent: :destroy

  def full_name
    "#{last_name} #{first_name}"
  end

  def timecard_error
    days = Day.where(date: self.hire_date...Date.today)
    days.each do |d|
      timecard = d.timecards.find_by(user_id: self.id)
      schedule = d.schedules.find_by(user_id: self.id)
      # 平日で休暇日程もない日で、出退勤がそろっていない
      if d.day_type == "平日"
        if schedule.nil? || schedule && schedule.schedule_type.blank? || schedule && schedule.schedule_type == "有休(AM)" || schedule && schedule.schedule_type == "有休(PM)"
          unless timecard && timecard.start && timecard.finish
            return true
          end
        end
      end
      # 休日に休暇日程をとっている
      if d.day_type.include?("休日") && schedule && schedule.schedule_type.present?
        return true
      end
      # 半休以外の休暇取得日に打刻している
      if schedule && schedule.schedule_type.present? && schedule.schedule_type != "有休(AM)" && schedule.schedule_type != "有休(PM)"
        if timecard && timecard.start.present?
          return true
        end
        if timecard && timecard.finish.present?
          return true
        end
        if timecard && timecard.break_start.present?
          return true
        end
        if timecard && timecard.break_finish.present?
          return true
        end
      end
      # 出勤 < 休始 < 休終 < 退勤 になっていない
      if timecard && timecard.start.present? && timecard.finish.present?
        unless timecard.start < timecard.finish
          return true
        end
        if timecard.break_start.present? && timecard.break_finish.present?
          unless timecard.start < timecard.break_start && timecard.break_start < timecard.break_finish && timecard.break_finish < timecard.finish
            return true
          end
        end
      end
      # 出勤があって退勤がない
      if timecard && timecard.start.present? && timecard.finish.blank?
        return true
      end
      # 退勤があって出勤がない
      if timecard && timecard.finish.present? && timecard.start.blank?
        return true
      end
      # 休始があって休終がない
      if timecard && timecard.break_start.present? && timecard.break_finish.blank?
        return true
      end
      # 休終があって休始がない
      if timecard && timecard.break_finish.present? && timecard.break_start.blank?
        return true
      end
    end
    return false
  end

  def travel_cost_error
    days = Day.where(date: self.hire_date...Date.today)
    days.each do |d|
      timecard = d.timecards.find_by(user_id: self.id)
      travel_cost = d.travel_costs.find_by(user_id: self.id)
      if timecard && timecard.start.present? && timecard.finish.present?
        unless travel_cost
          return true
        end
      else
        if travel_cost
          return true
        end
      end
    end
    return false
  end

end
