class CreatePendingTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_times do |t|
      t.references :timecard, foreign_key: true, null: false
      t.time :start
      t.time :finish
      t.time :break_start
      t.time :break_finish
      t.string :status
      t.text :comment_request
      t.text :comment_permission

      t.timestamps
    end
  end
end
