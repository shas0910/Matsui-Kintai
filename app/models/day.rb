class Day < ApplicationRecord

  belongs_to :year_month, optional: true

  validates :date, :day_type, :availability, presence: true
  validates :availability, inclusion: { in: [true, false] }
end
