class Upload < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :attachable, polymorphic: true
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.timestamps
    end
  end
end
