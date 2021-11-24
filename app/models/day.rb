class Day < ApplicationRecord

  belongs_to :year_month
  has_many :timecards, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :travel_costs, dependent: :destroy

  validates :date, :day_type, presence: true
  validates :date, uniqueness: true
end
