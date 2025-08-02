class CreateCalleds < ActiveRecord::Migration[7.0]
  def change
    create_table :calleds do |t|
      t.string :subject, null: false
      t.string :searchable_subject, null: false, default: ''

      t.text :message, null: false
      t.text :searchable_message, null: false, default: ''

      t.text :answer
      t.text :searchable_answer, null: false, default: ''

      t.references :subscription, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE calleds_id_seq RESTART WITH 1001;
    SQL

    add_index :calleds, 'LOWER(subject), subscription_id', unique: true

    add_column :subscriptions, :calleds_count, :bigint, null: false, default: 0
  end
end
