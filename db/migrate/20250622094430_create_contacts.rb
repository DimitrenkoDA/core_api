class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.references :owner, null: false, index: true
      t.references :user, null: false

      t.timestamps
    end

    add_index :contacts, [:owner_id, :user_id], unique: true
  end
end
