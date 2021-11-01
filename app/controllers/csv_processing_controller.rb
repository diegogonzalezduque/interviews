require 'csv'
class CsvProcessingController < ApplicationController
    @@column_names
    @@file
    def new 
        p = params
    end

    def create
        column_matcher = params[:matcher]
        byebug
        name_col = @@column_names.find_index(column_matcher[:name])
        phone_col = @@column_names.find_index(column_matcher[:phone])
        date_of_birth = @@column_names.find_index(column_matcher[:birth_date])
        address = @@column_names.find_index(column_matcher[:address])
        credit_card = @@column_names.find_index(column_matcher[:credit_card])
        email = @@column_names.find_index(column_matcher[:email])

        CSV.foreach(@@file.path) do |row|
            current_user.contacts.create(row)
        end

    end

    def column_matcher
        @@file = params[:csv][:csv_file]
        @@column_names = CSV.foreach(@@file.path).first.map(&:strip)
        @column_names = @@column_names
    end

end
