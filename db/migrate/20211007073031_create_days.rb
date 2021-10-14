class CreateDays < ActiveRecord::Migration[6.1]
  def change
    create_table :days do |t|
      t.references :year_month, foreign_key: true, null: false
      t.date :date, null: false
      t.string :day_type, null: false

      t.timestamps
    end
  end
end
