class CreatePlaceWorks < ActiveRecord::Migration
  def change
    create_table :place_works do |t|
      t.string :job_name
      t.string :short_name
      t.text :information

      t.timestamps null: false
    end
  end
end
