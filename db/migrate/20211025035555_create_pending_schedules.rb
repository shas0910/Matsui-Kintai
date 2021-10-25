class CreatePendingSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_schedules do |t|
      t.references :schedule, null: false, foreign_key: true
      t.string :schedule, null: false
      t.text :remark
      t.text :comment_request
      t.text :comment_permission

      t.timestamps
    end
  end
end
