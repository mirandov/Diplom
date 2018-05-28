class AddFieldToDiagnosis < ActiveRecord::Migration
  def change
    add_column :diagnoses, :first_in_live, :boolean
    add_column :diagnoses, :prof, :boolean
  end
end
