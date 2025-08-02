class CreateNotificators < ActiveRecord::Migration[7.0]
  def change
    create_table :notificators do |t|
      t.string :name, null: false
      t.string :searchable_name, null: false, default: ''

      t.boolean :actived, null: false, default: false

      t.string :token, null: false

      t.timestamps null: false
    end

    execute <<~SQL
      ALTER SEQUENCE notificators_id_seq RESTART WITH 1001;
    SQL

    add_index :notificators, 'LOWER(name)', unique: true
    add_index :notificators, 'LOWER(token)', unique: true
  end
end
