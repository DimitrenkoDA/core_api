class CreateJoinTableIncomesUserCategories < ActiveRecord::Migration[7.1]
  def change
    create_join_table :incomes, :user_categories do |t|
      t.index [:income_id, :user_category_id], unique: true
    end
  end
end
