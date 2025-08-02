class CreateProprietors < ActiveRecord::Migration[7.0]
  def change
    create_table :proprietors do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.text :notes

      t.references :subscription, null: false, foreign_key: true, index: true

      t.string :searchable_name, null: false, default: ''
      t.string :searchable_email, null: false, default: ''

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE proprietors_id_seq RESTART WITH 1001;
    SQL

    add_index :proprietors, 'LOWER(email), subscription_id', unique: true

    add_column :subscriptions, :proprietors_count, :bigint, null: false, default: 0
  end
end
