class CsvProcessing < ApplicationRecord
  belongs_to :user
  has_many :contact_uploads
  as_enum :status, %i{on_hold processing failed terminated}
end
