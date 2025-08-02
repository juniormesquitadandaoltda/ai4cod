class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits do |t|
      t.string   :item_type, null: false
      t.bigint   :item_id,   null: false
      t.string   :event,     null: false

      t.jsonb    :object, null: false, default: {}
      t.jsonb    :object_changes, null: false, default: {}

      t.references :whodunnit, null: false, foreign_key: { to_table: :users }, index: true
      t.references :owner, null: false, foreign_key: { to_table: :users }, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE audits_id_seq RESTART WITH 1001;
    SQL

    add_index :audits, %i[item_type item_id]

    add_column :users, :audits_count, :bigint, null: false, default: 0
  end
end
