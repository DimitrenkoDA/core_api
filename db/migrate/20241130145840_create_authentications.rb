class CreateAuthentications < ActiveRecord::Migration[7.1]
  def change
    create_table :authentications do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :prev_authentication, null: true, index: true
      t.string :step, null: false
      t.string :code
      t.jsonb :props
      t.timestamp :expires_at

      t.timestamps
    end

    add_index :authentications, :step
  end
end
