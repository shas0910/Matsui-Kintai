class PaidVacation < ApplicationRecord

  belongs_to :user

  def remain_limit
    if granted_date.month - User.find(user_id).hire_date.month >= 0
      yos = granted_date.year - User.find(user_id).hire_date.year
    else
      yos = granted_date.year - User.find(user_id).hire_date.year - 1
    end
    if yos == 0
      remain_limit = 10
    elsif yos == 1
      remain_limit = 11
    elsif yos == 2
      remain_limit = 12
    elsif yos == 3
      remain_limit = 14
    elsif yos == 4
      remain_limit = 16
    elsif yos == 5
      remain_limit = 18
    elsif yos >= 6
      remain_limit = 20
    end
    return remain_limit
  end
end
