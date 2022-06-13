class ChangeDataGrantToPaidVacation < ActiveRecord::Migration[6.1]
  def change
    change_column :paid_vacations, :grant, :float
  end
end
