class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :stage, null: false, index: true
      t.string :next_stage, index: true

      t.string :searchable_name, null: false, default: ''

      t.datetime :scheduling_at

      t.references :vehicle, null: false, foreign_key: true, index: true
      t.references :subscription, null: false, foreign_key: true, index: true

      t.boolean :shared, null: false, default: false

      t.references :facilitator, foreign_key: true, index: true
      t.references :proprietor, foreign_key: true, index: true

      t.text :notes

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE tasks_id_seq RESTART WITH 1001;
    SQL

    add_column :subscriptions, :tasks_count, :bigint, null: false, default: 0
  end
end
