class Contact < ApplicationRecord
  belongs_to :user

  def credit_card_franchise
    self.franchise = CreditCardValidations::Detector.new(credit_card).brand
  end

  def birthday_format_validation
    date = nil
    ALLOWED_DATE_FORMATS.each do |format|
      begin
        date ||= Date.strptime(read_attribute_before_type_cast(:dob), format)
      rescue Date::Error
        next
      end
    end
  end

  def encrypt_cc
    self[:encrypted_credit_card_number] = BCrypt::Password.create credit_card

    self[:credit_card] = credit_card.delete('^0-9').last(4)
  end

  def unique_email?
    unique = Contact.where(email: email, user_id: user_id).count > 0
    return unique
  end



end
