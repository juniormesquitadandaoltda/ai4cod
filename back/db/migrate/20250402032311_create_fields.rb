class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.string :resource, null: false
      t.string :name, null: false

      t.jsonb :values, null: false, default: []

      t.references :subscription, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE fields_id_seq RESTART WITH 1001;
    SQL

    add_index :fields, %i[name resource subscription_id], unique: true

    add_column :subscriptions, :fields_count, :bigint, null: false, default: 0
  end
end
