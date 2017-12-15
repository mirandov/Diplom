class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :surname
      t.string :name
      t.string :patronymic
      t.string :personnel_number
      t.text :information

      t.timestamps null: false
    end
  end
end
