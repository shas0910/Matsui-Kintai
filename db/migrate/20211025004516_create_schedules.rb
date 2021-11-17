class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.string :schedule_type
      t.timestamps
    end
  end
end
