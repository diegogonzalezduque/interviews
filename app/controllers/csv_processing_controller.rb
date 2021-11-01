require 'csv'
class CsvProcessingController < ApplicationController
    @@column_names
    @@file
    @@file_path
    def new 
        p = params
    end

    def create
        column_matcher = params[:matcher]

        name_col = @@column_names.find_index(column_matcher[:name])
        phone_col = @@column_names.find_index(column_matcher[:phone])
        date_of_birth = @@column_names.find_index(column_matcher[:date_of_birth])
        address = @@column_names.find_index(column_matcher[:address])
        credit_card = @@column_names.find_index(column_matcher[:credit_card])
        email = @@column_names.find_index(column_matcher[:email])
        @@file_path.each do |row|
            contact = Contact.new
            contact.name = row[name_col]
            #contact.date_of_birth = row[date_of_birth]
            contact.phone = row[phone_col]
            contact.address = row[address]
            contact.credit_card = row[credit_card]
            contact.email = row[email]
            if contact.validator  row[date_of_birth]
                current_user.contacts << contact
                contact.save!
            end
        end

    end

    def column_matcher
        @@file = params[:csv][:csv_file]
        @@file_path = @@file.path
        @@column_names = CSV.foreach(@@file.path).first.map(&:strip)
        csv_parsing
        @column_names = @@column_names
    end

    def csv_parsing
        list_row = []
        count = 0
        CSV.foreach(@@file.path) do |row|
            list_row << row if count > 0
            count = count + 1
        end
        @@file_path = list_row
    end

end
