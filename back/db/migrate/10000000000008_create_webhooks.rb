class CreateWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.string :url, null: false
      t.boolean :actived, null: false, default: false

      t.string :resource, null: false
      t.string :event, null: false

      t.jsonb :request_metadata, null: false, default: {}
      t.integer :requests_count, null: false, default: 0
      t.timestamp :requested_at
      t.references :subscription, null: false, foreign_key: true, index: true

      t.string :searchable_url, null: false, default: ''

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE webhooks_id_seq RESTART WITH 1001;
    SQL

    add_index :webhooks, 'LOWER(url), event, subscription_id', unique: true

    add_column :subscriptions, :webhooks_count, :bigint, null: false, default: 0
  end
end
