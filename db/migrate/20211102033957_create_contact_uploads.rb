class CreateContactUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_uploads do |t|
      t.references :csv_processing, null: false, foreign_key: true
      t.text :contact_name
      t.integer :status_cd
      t.text :error_message

      t.timestamps
    end
  end
end
