class CreatePreviousPasswords < ActiveRecord::Migration[8.0]
  def change
    create_table :previous_passwords do |t|
      t.string :salt, null: false
      t.string :encrypted_password, null: false
      t.references :user, null: false, foreign_key: true, index: true, type: :bigint

      t.timestamps
    end

    add_index :previous_passwords, :encrypted_password
    add_index :previous_passwords, [:user_id, :created_at]
  end
end
