class PaidVacation < ApplicationRecord

  belongs_to :user
  
  # 有給残日数
  def remain
    grant + carry
  end

end
