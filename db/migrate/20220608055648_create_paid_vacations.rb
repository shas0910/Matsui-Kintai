class CreatePaidVacations < ActiveRecord::Migration[6.1]
  def change
    create_table :paid_vacations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :remain
      t.timestamps
    end
  end
end
