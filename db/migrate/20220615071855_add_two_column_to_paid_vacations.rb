class AddTwoColumnToPaidVacations < ActiveRecord::Migration[6.1]
  def change
    add_column :paid_vacations, :remain, :float
    add_column :paid_vacations, :granted_date, :date
  end
end
