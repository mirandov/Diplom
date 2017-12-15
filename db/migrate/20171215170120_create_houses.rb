class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :house_number
      t.references :street, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
