class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :site_name
      t.string :short_name
      t.string :region
      t.text :information

      t.timestamps null: false
    end
  end
end
