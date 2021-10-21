class Timecard < ApplicationRecord
  belongs_to :user
  belongs_to :day
  has_many :pending_timecards
end
