class AddColumnToPaidVacations < ActiveRecord::Migration[6.1]
  def change
    add_column :paid_vacations, :grant, :integer
    add_column :paid_vacations, :carry, :integer
  end
end
