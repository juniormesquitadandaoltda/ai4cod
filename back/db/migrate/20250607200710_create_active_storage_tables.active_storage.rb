class CreateActiveStorageTables < ActiveRecord::Migration[7.0]
  def change
    create_table :active_storage_blobs do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :filename, null: false
      t.string :content_type
      t.jsonb :metadata, null: false, default: {}
      t.string :service_name, null: false
      t.bigint :byte_size, null: false
      t.string :checksum

      t.string :searchable_filename, null: false, default: ''

      t.timestamps null: false
    end

    create_table :active_storage_attachments do |t|
      t.string :name, null: false
      t.references :record, null: false, polymorphic: true, index: true
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }, index: true

      t.references :subscription, foreign_key: true, index: true

      t.string :searchable_record_type, null: false, default: ''

      t.timestamps null: false

      t.index %i[name record_type record_id blob_id], name: :index_active_storage_attachments_uniqueness, unique: true
    end

    create_table :active_storage_variant_records do |t|
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }, index: false
      t.string :variation_digest, null: false

      t.timestamps null: false

      t.index %i[blob_id variation_digest], name: :index_active_storage_variant_records_uniqueness, unique: true
    end

    execute <<~SQL
      ALTER SEQUENCE active_storage_blobs_id_seq RESTART WITH 1001;
    SQL

    execute <<~SQL
      ALTER SEQUENCE active_storage_attachments_id_seq RESTART WITH 1001;
    SQL

    execute <<~SQL
      ALTER SEQUENCE active_storage_variant_records_id_seq RESTART WITH 1001;
    SQL

    add_column :subscriptions, :archives_count, :bigint, null: false, default: 0
  end
end
