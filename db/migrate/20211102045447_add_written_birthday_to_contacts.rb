class AddWrittenBirthdayToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :written_birthday, :string
  end
end
