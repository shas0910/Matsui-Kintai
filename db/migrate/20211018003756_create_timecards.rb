class CreateTimecards < ActiveRecord::Migration[6.1]
  def change
    create_table :timecards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.time :start
      t.time :finish
      t.time :break_start
      t.time :break_finish

      t.timestamps
    end
  end
end
