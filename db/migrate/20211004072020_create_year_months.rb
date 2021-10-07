class CreateYearMonths < ActiveRecord::Migration[6.1]
  def change
    create_table :year_months do |t|
      t.integer :year, null: false
      t.integer :month, null: false
      t.date :first_date, null: false
      t.date :last_date, null: false

      t.timestamps
    end
  end
end
