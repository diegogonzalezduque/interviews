class ContactUpload < ApplicationRecord
  as_enum :status, %i{successful failed}
  belongs_to :csv_processing
end
