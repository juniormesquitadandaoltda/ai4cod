class CreateCollaborators < ActiveRecord::Migration[7.0]
  def change
    create_table :collaborators do |t|
      t.boolean :actived, null: false, default: false
      t.references :user, null: false, foreign_key: true, index: true
      t.references :subscription, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE collaborators_id_seq RESTART WITH 1001;
    SQL

    add_index :collaborators, %i[user_id subscription_id], unique: true

    add_column :users, :collaborations_count, :bigint, null: false, default: 0
    add_column :subscriptions, :collaborators_count, :bigint, null: false, default: 0
  end
end
