class AddReferencesToDiagnosis < ActiveRecord::Migration
  def change
    add_reference :diagnoses, :complictation, index: true, foreign_key: true
    add_reference :diagnoses, :doctor, index: true, foreign_key: true
    add_reference :diagnoses, :class_disease, index: true, foreign_key: true
  end
end
