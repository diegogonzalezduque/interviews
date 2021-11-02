class Contact < ApplicationRecord
  ALLOWED_DATE_FORMATS = %w[%Y%m%d %F].freeze
  ALLOWED_FRANCHISES = %i[amex discover jcb mastercard visa diners].freeze
  belongs_to :user

  before_create :encrypt_cc
  validates :email, uniqueness: {scope: :user_id}
  before_validation :credit_card_franchise, :check_name, :address_validator, :telephone_check, :birthday_format_validation


  def credit_card_franchise
    self.franchise = CreditCardValidations::Detector.new(credit_card).brand
    self.errors.add(:base, "Credit card invalid") unless self.franchise.present?
  end

  def birthday_format_validation
    date = nil
    ALLOWED_DATE_FORMATS.each do |format|
      begin
        date ||= Date.strptime(self.written_birthday.strip, format)
      rescue Date::Error
        next
      end
      self.errors.add(:base, "Invalid Birthday") unless date.present?
    end
    if date.present?
      self.date_of_birth = date
    end
  end

  def encrypt_cc
    self[:encrypted_credit_card_number] = BCrypt::Password.create credit_card
    self[:credit_card] = credit_card.delete('^0-9').last(4)
  end

  def check_name
    regular_exp = /([a-zA-Z]|-|[0-9])*/
    self.errors.add(:base, "Invalid name") if self.name != self.name.match(regular_exp)[0]
  end

  def address_validator
    self.errors.add(:base, "Invalid address") if !self.address || self.address == "" || self.address == nil
  end

  def telephone_check
    telephone_regex = /(\(\+[0-9][0-9]\)\s([0-9][0-9][0-9]\s){2}([0-9][0-9]\s){2}[0-9][0-9])|(\(\+[0-9][0-9]\)\s([0-9][0-9][0-9]-){2}[0-9][0-9]-[0-9][0-9])/
    check = self.phone.match(telephone_regex)
    if check.nil?
      self.errors.add(:base, "Invalid phone")
    end
  end

end
