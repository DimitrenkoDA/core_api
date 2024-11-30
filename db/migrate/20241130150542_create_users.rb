class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false

      t.string :first_name
      t.string :last_name
      t.string :birth_date

      t.timestamps
    end
  end
end
