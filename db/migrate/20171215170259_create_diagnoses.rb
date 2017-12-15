class CreateDiagnoses < ActiveRecord::Migration
  def change
    create_table :diagnoses do |t|
      t.date :resolution_date
      t.references :patient, index: true, foreign_key: true
      t.references :position, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
