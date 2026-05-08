class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :full_name, null: false
      t.string :email
      t.string :phone
      t.string :status, null: false, default: "active"
      t.text :summary
      t.text :sensitive_notes
      t.references :professional, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :patients, :status
  end
end
