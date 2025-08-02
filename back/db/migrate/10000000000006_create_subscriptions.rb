class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :name, null: false
      t.boolean :actived, null: false, default: false
      t.references :user, null: false, foreign_key: true, index: true

      t.string :searchable_name, null: false, default: ''

      t.date :due_date, null: false

      t.bigint :current_records_count, null: false, default: 0
      t.bigint :maximum_records_count, null: false, default: 0

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE subscriptions_id_seq RESTART WITH 1001;
    SQL

    add_index :subscriptions, 'LOWER(name), user_id', unique: true

    add_column :users, :subscriptions_count, :bigint, null: false, default: 0
  end
end
