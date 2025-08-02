class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: '', index: true
      t.string :encrypted_password, null: false, default: ''

      t.string :reset_password_token, unique: true
      t.timestamp :reset_password_sent_at

      t.timestamp :remember_created_at

      t.bigint :sign_in_count, default: 0, null: false
      t.timestamp :current_sign_in_at
      t.timestamp :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.string :confirmation_token, unique: true
      t.timestamp :confirmed_at
      t.timestamp :confirmation_sent_at
      t.string :unconfirmed_email

      t.bigint :failed_attempts, default: 0, null: false
      t.string :unlock_token, unique: true
      t.timestamp :locked_at

      t.string :name, null: false
      t.string :profile, null: false
      t.string :status, null: false
      t.string :timezone, null: false
      t.string :locale, null: false

      t.string :searchable_email, null: false, default: ''
      t.string :searchable_name, null: false, default: ''

      t.timestamp :destroyed_at
      t.timestamp :access_sent_at

      t.boolean :policy_terms, null: false, default: false

      t.uuid :uuid, null: false, default: 'uuid_generate_v4()', index: { unique: true }

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE users_id_seq RESTART WITH 1001;
    SQL

    add_index :users, 'LOWER(email)', unique: true
  end
end
