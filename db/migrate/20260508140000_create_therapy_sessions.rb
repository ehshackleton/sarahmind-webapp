class CreateTherapySessions < ActiveRecord::Migration[7.2]
  def change
    create_table :therapy_sessions do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :professional, null: false, foreign_key: { to_table: :users }
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :status, null: false, default: "scheduled"
      t.text :notes
      t.string :google_calendar_event_id

      t.timestamps
    end

    add_index :therapy_sessions, :starts_at
    add_index :therapy_sessions, :status
  end
end
