ActiveRecord::Schema[8.0].define(version: 2017_12_27_042253) do

  create_table "users", force: :cascade, id: :bigint do |t|
    ## Database authenticatable
    t.string "email", null: false, default: ""
    t.string "encrypted_password", null: false, default: ""

    ## Recoverable
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"

    ## Rememberable
    t.datetime "remember_created_at"

    ## Trackable
    t.integer  "sign_in_count", null: false, default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"

    ## Timestamps
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    ## Indexes
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    # t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    # t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "previous_passwords", force: :cascade, id: :bigint do |t|
    t.string  "salt", null: false
    t.string  "encrypted_password", null: false
    t.bigint  "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    ## Indexes
    t.index ["encrypted_password"], name: "index_previous_passwords_on_encrypted_password"
    t.index ["user_id", "created_at"], name: "index_previous_passwords_on_user_id_and_created_at"
  end

  ## Foreign keys
  add_foreign_key "previous_passwords", "users"
end
