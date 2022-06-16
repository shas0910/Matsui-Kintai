#毎日の有休管理処理
class Batch::Grant
  # def self.grant
  #   # 付与日から2年経過した有休を消す
  #   PaidVacation.all.each do |pv|
  #     if pv.granted_date.since(2.years) <= Date.today
  #       puts "delete #{pv.remain} days from #{User.find(pv.user_id).full_name}"
  #       pv.destroy
  #     end
  #   end
  #   # 有休付与
  #   User.where.not(user_type: "管理者").each do |u|
  #     if Date.today.month == u.grant_date.month && Date.today.day == u.grant_date.day
  #       paid_vacation =  PaidVacation.new
  #       paid_vacation.user_id = u.id
  #       paid_vacation.remain = u.grant_limit
  #       paid_vacation.granted_date = Date.today
  #       paid_vacation.save
  #       puts "grant #{paid_vacation.remain} days to #{u.full_name}"
  #     end
  #   end
  puts "test"
  end
end