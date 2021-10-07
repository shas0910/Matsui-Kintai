class YearMonth < ApplicationRecord
  
  has_many :days

  with_options presence: true do
    validates :year, uniqueness: { scope: :month }
    validates :month
    validates :first_date
    validates :last_date
  end

end
