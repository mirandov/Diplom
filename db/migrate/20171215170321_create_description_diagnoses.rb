class CreateDescriptionDiagnoses < ActiveRecord::Migration
  def change
    create_table :description_diagnoses do |t|
      t.text :comment
      t.references :diagnosis, index: true, foreign_key: true
      t.references :complictation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
