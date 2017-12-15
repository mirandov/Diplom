class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :site, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
      t.references :street, index: true, foreign_key: true
      t.references :house, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
