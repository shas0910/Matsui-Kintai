class CreateCommutes < ActiveRecord::Migration[6.1]
  def change
    create_table :commutes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :car_type
      t.string :car_route
      t.integer :car_distance
      t.string :pass_route
      t.integer :pass_fee

      t.timestamps
    end
  end
end
