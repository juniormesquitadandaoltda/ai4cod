class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :url, null: false

      t.jsonb :headers, null: false, default: {}
      t.jsonb :body, null: false, default: {}

      t.references :notificator, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE notifications_id_seq RESTART WITH 1001;
    SQL

    add_column :notificators, :notifications_count, :bigint, null: false, default: 0
  end
end
