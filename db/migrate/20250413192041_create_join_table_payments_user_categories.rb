class CreateJoinTablePaymentsUserCategories < ActiveRecord::Migration[7.1]
  def change
    create_join_table :payments, :user_categories do |t|
      t.index [:payment_id, :user_category_id], unique: true
    end
  end
end
