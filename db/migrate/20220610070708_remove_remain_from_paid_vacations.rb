class RemoveRemainFromPaidVacations < ActiveRecord::Migration[6.1]
  def change
    remove_column :paid_vacations, :remain, :integer
  end
end
