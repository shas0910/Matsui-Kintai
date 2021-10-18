class Day < ApplicationRecord

  belongs_to :year_month
  has_many :timecards

  validates :date, :day_type, presence: true
  validates :date, uniqueness: true
end
