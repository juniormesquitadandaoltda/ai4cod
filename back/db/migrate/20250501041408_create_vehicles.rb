class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :chassis, null: false
      t.string :year, null: false

      t.string :brand, null: false, index: true
      t.string :model, null: false, index: true
      t.string :color, null: false, index: true
      t.string :fuel, null: false, index: true
      t.string :category, null: false, index: true
      t.string :kind, null: false, index: true

      t.string :plate
      t.string :renavam
      t.string :licensing

      t.string :searchable_chassis, null: false, default: ''
      t.string :searchable_year, null: false, default: ''
      t.string :searchable_plate, null: false, default: ''
      t.string :searchable_renavam, null: false, default: ''
      t.string :searchable_licensing, null: false, default: ''

      t.integer :seats, null: false, default: 0

      t.text :notes

      t.references :subscription, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE vehicles_id_seq RESTART WITH 1001;
    SQL

    add_index :vehicles, 'LOWER(chassis), subscription_id', unique: true

    add_column :subscriptions, :vehicles_count, :bigint, null: false, default: 0
  end
end
