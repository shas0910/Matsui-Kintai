class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :timecards, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_one :commute, dependent: :destroy
  has_many :travel_costs, dependent: :destroy
  has_many :paid_vacation, dependent: :destroy

  # フルネーム表示
  def full_name
    "#{last_name} #{first_name}"
  end

  # 有給付与日
  def grant_date
    grant_date = hire_date >> 6
    if grant_date.month == 2 && grant_date.day == 29
      grant_date = grant_date - 1
    end
    return grant_date
  end

  # 勤続年
  def years_of_service
    if Date.today.month - hire_date.month >= 0
      years_of_service = Date.today.year - hire_date.year
    else
      years_of_service = Date.today.year - hire_date.year - 1
    end
    return years_of_service
  end

  # 勤続年数ごとの付与日上限
  def grant_limit
    if years_of_service == 0
      grant_limit = 10
    elsif years_of_service == 1
      grant_limit = 11
    elsif years_of_service == 2
      grant_limit = 12
    elsif years_of_service == 3
      grant_limit = 14
    elsif years_of_service == 4
      grant_limit = 16
    elsif years_of_service == 5
      grant_limit = 18
    elsif years_of_service >= 6
      grant_limit = 20
    end
    return grant_limit
  end

  # 残有休トータル
  def remain_total
    PaidVacation.where(user_id: id).sum(:remain)
  end
end
