class RemoveGrantFromPaidVacations < ActiveRecord::Migration[6.1]
  def change
    remove_column :paid_vacations, :grant, :float
  end
end
