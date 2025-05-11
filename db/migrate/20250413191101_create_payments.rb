class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, index: true
      t.references :transaction, null: true, index: true
      t.monetize :amount, null: false
      t.text :note

      t.timestamps
    end
  end
end
