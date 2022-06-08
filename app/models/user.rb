class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :timecards, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_one :commute, dependent: :destroy
  has_many :travel_costs, dependent: :destroy
  has_one :paid_vacation, dependent: :destroy

  def full_name
    "#{last_name} #{first_name}"
  end

  def grant_date
    grant_date = hire_date >> 6
    if grant_date.month == 2 && grant_date.day == 29
      grant_date = grant_date - 1
    end
    return grant_date
  end
end
