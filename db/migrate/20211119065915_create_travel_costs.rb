class CreateTravelCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :travel_costs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.string :commute_type, null: false
      t.integer :travel_cost, null: false
      t.string :remark

      t.timestamps
    end
  end
end
