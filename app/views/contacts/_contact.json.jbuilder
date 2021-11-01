json.extract! contact, :id, :name, :date_of_birth, :phone, :address, :credit_card, :franchise, :email, :created_at, :updated_at
json.url contact_url(contact, format: :json)
