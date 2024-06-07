class CreatePreviousPasswords < ActiveRecord::Migration[7.0]
  def up
    create_table :previous_passwords do |t|
      t.string :salt, null: false
      t.string :encrypted_password, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :previous_passwords, :encrypted_password
    add_index :previous_passwords, [:user_id, :created_at]
  end
end
