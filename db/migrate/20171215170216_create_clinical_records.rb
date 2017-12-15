class CreateClinicalRecords < ActiveRecord::Migration
  def change
    create_table :clinical_records do |t|
      t.string :record_number
      t.string :prefix
      t.string :suffix
      t.date :attachment_date
      t.date :last_registration_date
      t.date :detachment_date
      t.text :reason_for_detachment
      t.references :site, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
