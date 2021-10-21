class CreatePendingTimecards < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_timecards do |t|
      t.references :timecard, null: false, foreign_key: true
      t.time :start
      t.time :finish
      t.time :break_start
      t.time :break_finish
      t.string :status, null: false
      t.text :comment_request
      t.text :comment_permission

      t.timestamps
    end
  end
end
