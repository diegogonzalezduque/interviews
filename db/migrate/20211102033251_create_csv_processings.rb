class CreateCsvProcessings < ActiveRecord::Migration[6.1]
  def change
    create_table :csv_processings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status_cd

      t.timestamps
    end
  end
end
