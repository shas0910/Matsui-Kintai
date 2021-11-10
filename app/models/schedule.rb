class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :day
  has_many :pending_schedules, dependent: :destroy
end
