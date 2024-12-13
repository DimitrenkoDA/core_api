class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :polarity, null: false
      t.monetize :amount

      t.timestamps
    end
  end
end
