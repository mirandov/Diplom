class AddFieldReport < ActiveRecord::Migration
  def change
    add_column :reports, :report_data, :json
    add_column :reports, :name, :string
    add_column :reports, :report_type, :integer
    add_column :reports, :date_of_create, :date
  end
end
