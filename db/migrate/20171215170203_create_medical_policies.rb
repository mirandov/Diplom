class CreateMedicalPolicies < ActiveRecord::Migration
  def change
    create_table :medical_policies do |t|
      t.string :mip_number
      t.references :address, index: true, foreign_key: true
      t.references :patient, foreign_key: true

      t.index :patient_id, unique: true
      t.timestamps null: false
    end
  end
end
