class CreateUserCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :user_categories do |t|
      t.integer :user_id, null: false, index: true
      t.string :kind, null: false
      t.string :colour_code, null: false, default: "#fff000"
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
