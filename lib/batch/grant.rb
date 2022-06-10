#有給付与の処理

class Batch::Grant
  def self.grant
    User.where.not(user_type: "管理者").each do |u|
      if Date.today.month == u.grant_date.month && Date.today.day == u.grant_date.day
        years_of_service = 0
        g = 0
        if Date.today.month - u.hire_date.month >= 0
          years_of_service = Date.today.year - u.hire_date.year
        else
          years_of_service = Date.today.year - u.hire_date.year - 1
        end
        if years_of_service == 0
          g = 10
        elsif years_of_service == 1
          g = 11
        elsif years_of_service == 2
          g = 12
        elsif years_of_service == 3
          g = 14
        elsif years_of_service == 4
          g = 16
        elsif years_of_service == 5
          g = 18
        elsif years_of_service >= 6
          g = 20
        end
        paid_vacation =  PaidVacation.find_or_initialize_by(user_id: u.id)
        if paid_vacation.new_record?
          paid_vacation.grant = 0
          paid_vacation.carry = 0
          paid_vacation.save
        end
        paid_vacation.update_attribute(:carry, PaidVacation.find_by(user_id: u.id).grant)
        paid_vacation.update_attribute(:grant, g)
      else
        puts "no grant day for " + u.full_name
      end
    end
  end
end