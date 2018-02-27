class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :surname
      t.string :name
      t.string :patronymic
      t.date :birthday
      t.string :sex
      t.string :full_name_parent
      t.string :mobile_phone_number
      t.string :work_phone_number
      t.string :rank
      t.string :disability
      t.string :certificate_of_deceased_parent
      t.string :certificate_of_nuclear_power_plant
      t.string :inila
      t.references :place_work, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true


      t.timestamps null: false
    end
  end
end
