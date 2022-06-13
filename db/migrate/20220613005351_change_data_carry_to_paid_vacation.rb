class ChangeDataCarryToPaidVacation < ActiveRecord::Migration[6.1]
  def change
    change_column :paid_vacations, :carry, :float
  end
end
