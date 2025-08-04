class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.text :question, null: false
      t.text :answer, null: false
      t.integer :tokens_count, null: false, default: 0

      t.references :subscription, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE chats_id_seq RESTART WITH 1001;
    SQL

    add_column :subscriptions, :chats_count, :bigint, null: false, default: 0
    add_column :subscriptions, :tokens_count, :bigint, null: false, default: 0
  end
end
