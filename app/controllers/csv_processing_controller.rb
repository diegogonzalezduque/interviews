require 'csv'
class CsvProcessingController < ApplicationController
    @@column_names
    @@file
    @@file_path

    def index
        @csv_processings = current_user.csv_processings
    end

    def edit
        @contact_uploads = current_csv.contact_uploads
    end

    def new 
        p = params
    end

    def create
        csv_processing = current_user.csv_processings.create
        csv_processing.processing!

        column_matcher = params[:matcher]

        name_col = @@column_names.find_index(column_matcher[:name])
        phone_col = @@column_names.find_index(column_matcher[:phone])
        date_of_birth = @@column_names.find_index(column_matcher[:date_of_birth])
        address = @@column_names.find_index(column_matcher[:address])
        credit_card = @@column_names.find_index(column_matcher[:credit_card])
        email = @@column_names.find_index(column_matcher[:email])
        valid_file = false
        @@file_path.each do |row|
            contact = current_user.contacts.new(
              {
                name: row[name_col],
                written_birthday: row[date_of_birth],
                phone: row[phone_col],
                address: row[address],
                credit_card: row[credit_card],
                email: row[email],
              }
            )

            if contact.save
                csv_processing.contact_uploads.create({contact_name: contact.name, status: :successful})
                valid_file = true
            else
                csv_processing.contact_uploads.create({contact_name: contact.name, status: :failed, error_message: contact.errors.full_messages.join(", ")})
            end
        end

        if valid_file
            csv_processing.terminated!
        else
            csv_processing.failed!
        end
        csv_processing.save!
        redirect_to csv_processing_index_path
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

    private
    def current_csv
        CsvProcessing.find params[:id]
    end

end
