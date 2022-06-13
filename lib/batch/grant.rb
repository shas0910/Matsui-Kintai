#有給付与の処理

class Batch::Grant
  def self.grant
    User.where.not(user_type: "管理者").each do |u|
      if Date.today.month == u.grant_date.month && Date.today.day == u.grant_date.day
        paid_vacation =  PaidVacation.find_or_initialize_by(user_id: u.id)
        if paid_vacation.new_record?
          paid_vacation.grant = 0
          paid_vacation.carry = 0
          paid_vacation.save
        end
        paid_vacation.update_attribute(:carry, PaidVacation.find_by(user_id: u.id).grant)
        paid_vacation.update_attribute(:grant, u.grant_limit)
        puts "grant days to " + u.full_name
      end
    end
    puts "all granted"
  end
end