class Contact < ApplicationRecord
  ALLOWED_DATE_FORMATS = %w[%Y%m%d %F].freeze
  ALLOWED_FRANCHISES = %i[amex discover jcb mastercard visa diners].freeze
  belongs_to :user

  before_save :unique_email?


  def validator
    if credit_card_franchise && encrypt_cc && check_name && address_validator && telephone_check
      return true
    end
    return false
  end

  def credit_card_franchise
    self.franchise = CreditCardValidations::Detector.new(credit_card).brand
    if self.franchise != nil
      return true
    end
    return false
  end

  def birthday_format_validation
    date = nil
    ALLOWED_DATE_FORMATS.each do |format|
      begin
        date ||= Date.strptime(read_attribute_before_type_cast(:date_of_birth), format)
      rescue Date::Error
        next
      end
    end
    if date.nil?
      return false
    else
      self.date_of_birth = date_of_birth
      return true
    end
  end

  def encrypt_cc
    self[:encrypted_credit_card_number] = BCrypt::Password.create credit_card

    self[:credit_card] = credit_card.delete('^0-9').last(4)
    return true
  end

  def unique_email?
    unique = Contact.where(email: email, user_id: user_id).count
    return unique < 0
  end

  def check_name
    regular_exp = /([a-zA-Z]|-|[0-9])*/
    if self.name != self.name.match(regular_exp)[0]
      return false
    end
    return true
  end

  def address_validator
    if !self.address || self.address == "" || self.address == nil
      return false
    end
    return true
  end

  def telephone_check
    telephone_regex = /(\(\+[0-9][0-9]\)\s([0-9][0-9][0-9]\s){2}([0-9][0-9]\s){2}[0-9][0-9])|(\(\+[0-9][0-9]\)\s([0-9][0-9][0-9]-){2}[0-9][0-9]-[0-9][0-9])/
    check = self.phone.match(telephone_regex)
    if check.nil?
      return false
    elsif check[0] == self.phone
      return true
    end
  end



end
