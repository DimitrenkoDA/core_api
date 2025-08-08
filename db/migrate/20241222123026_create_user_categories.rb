class CreateUserCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :user_categories do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :kind, null: false
      t.string :colour_code, null: false, default: "#fff000"
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    add_index :user_categories, [:user_id, :name], unique: true
  end
end
