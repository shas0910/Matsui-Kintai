class AddKanaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_name_kana, :string, null: false
    add_column :users, :first_name_kana, :string, null: false
  end
end
