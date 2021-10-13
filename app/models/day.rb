class Day < ApplicationRecord

  belongs_to :year_month, optional: true

  validates :date, :day_type, presence: true
  validates :date, uniqueness: true
end
