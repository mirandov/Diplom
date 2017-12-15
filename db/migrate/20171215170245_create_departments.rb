class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :title
      t.string :short_title
      t.text :information

      t.timestamps null: false
    end
  end
end
