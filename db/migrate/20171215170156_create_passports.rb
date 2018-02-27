class CreatePassports < ActiveRecord::Migration
  def change
    create_table :passports do |t|
      t.string :serial_and_number
      t.date :issue_date
      t.string :issued_by
      t.string :passport_holder
      t.references :patient, foreign_key: true

      t.index :patient_id, unique: true
      t.timestamps null: false
    end
  end
end
