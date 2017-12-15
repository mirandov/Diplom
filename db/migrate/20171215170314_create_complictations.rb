class CreateComplictations < ActiveRecord::Migration
  def change
    create_table :complictations do |t|
      t.string :name
      t.string :code
      t.text :information
      t.references :class_disease, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
