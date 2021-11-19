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
end
