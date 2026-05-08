class CreateClinicalNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :clinical_notes do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :professional, null: false, foreign_key: { to_table: :users }
      t.text :body, null: false

      t.timestamps
    end
  end
end
