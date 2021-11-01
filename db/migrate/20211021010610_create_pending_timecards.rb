class CreatePendingTimecards < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_timecards do |t|
      t.references :timecard, null: false, foreign_key: true
      t.string :timecard_type, null: false
      t.time :pending_time
      t.string :status, null: false
      t.text :comment_request
      t.text :comment_permission

      t.timestamps
    end
  end
end
