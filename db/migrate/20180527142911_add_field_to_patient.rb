class AddFieldToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :address_live, :string
    add_column :patients, :address_reg, :string
  end
end
