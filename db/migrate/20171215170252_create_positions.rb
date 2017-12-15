class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position_name
      t.string :status
      t.references :doctor, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
