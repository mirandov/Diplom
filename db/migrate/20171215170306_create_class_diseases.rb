class CreateClassDiseases < ActiveRecord::Migration
  def change
    create_table :class_diseases do |t|
      t.string :name
      t.string :code
      t.text :information

      t.timestamps null: false
    end
  end
end
