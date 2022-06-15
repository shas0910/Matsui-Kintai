class RemoveCarryFromPaidVacations < ActiveRecord::Migration[6.1]
  def change
    remove_column :paid_vacations, :carry, :float
  end
end
