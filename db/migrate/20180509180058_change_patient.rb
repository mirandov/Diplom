class ChangePatient < ActiveRecord::Migration
  def change
    remove_column :patients, :sex
    add_column :patients, :sex, :boolean
  end
end
