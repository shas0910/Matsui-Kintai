class YearMonth < ApplicationRecord
  
  has_many :days, dependent: :destroy

  accepts_nested_attributes_for :days, allow_destroy: true, reject_if: :all_blank

  with_options presence: true do
    validates :year, uniqueness: { scope: :month }
    validates :month
    validates :first_date
    validates :last_date
  end

end
