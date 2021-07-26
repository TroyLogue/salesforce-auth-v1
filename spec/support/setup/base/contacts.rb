require 'uniteus-api-client'
require 'faker'

require_relative '../../../../lib/file_helper'

module Setup
  # An object that represents a contact/client created by a user in app-client
  class Contact
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_reader :fname, :lname, :dob, :dob_formatted, :military_affiliation_key
    attr_accessor :contact_id, :token, :group_id

    def initialize(token:, group_id:)
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Requests::Contacts.random_dob
      @dob_formatted = Time.at(@dob).strftime('%m/%d/%Y')
      @military_affiliation_key = 'caregiver'
      @insurance = []
      @contact_id = 0
      @token = token
      @group_id = group_id
    end

    def create
      request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob })
      contact_response = Requests::Contacts.create(token: @token, group_id: @group_id, contact: request_body)

      expect(contact_response.status.to_s).to eq('201 Created')
      @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
    end

    def create_with_consent
      create
      add_consent
    end

    def create_with_consent_token
      create
      consent_token
    end

    def create_with_military
      @military_affiliation_key = 'caregiver'
      military = Payloads::Military::Create.new(affiliation: military_affiliation_key)
      request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob,
                                                      military: military.to_h })
      contact_response = Requests::Contacts.create(token: @token, group_id: @group_id, contact: request_body)

      expect(contact_response.status.to_s).to eq('201 Created')
      @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
    end

    def create_with_military_and_consent
      create_with_military
      add_consent
    end

    # Uses a different token and group_id from the ones used to create the contact
    def select(token:, group_id:)
      contact_response = Requests::Contacts.search_and_select(token: token, group_id: group_id,
                                                              contact_id: @contact_id)
      expect(contact_response.status.to_s).to eq('200 OK')
    end

    def random_existing_client
      case ENV['ENVIRONMENT']
      when 'prod', 'training'
        # In non-testing environments, there is a smaller pool of clients to search from.
        # Removing query and time constraints gives us access to the largest pool of existing clients.
        contact_indexes_response = Requests::Contacts.client_index_without_query(
          token: token, group_id: group_id, page: 1
        )
        expect(contact_indexes_response.status.to_s).to eq('200 OK')
        contact = JSON.parse(contact_indexes_response, object_class: OpenStruct).data.sample
      when 'staging', 'devqa'
        # Searching clients with a random query_letter so no one client is used for all test cases
        # while on testing environments.
        # But when searching for clients, some query letters return 0 results;
        # we are searching clients using an array that has proven to be reliable
        default_retry_count = 2
        retry_count = 0
        contact = nil
        while contact.nil? && retry_count <= default_retry_count
          contact_indexes_response = Requests::Contacts.get_client_indexes(
            token: token, group_id: group_id,
            page: 1, query_letter: Faker::Alphanumeric.alphanumeric(number: 1, min_alpha: 1)
          )
          expect(contact_indexes_response.status.to_s).to eq('200 OK')
          # Searching for a consented client created within the past month
          # with ES-60 we migrated only contacts created since ~ Jan 2021 in testing environments;
          # in developing this method we saw reliable search results when scoped to one month
          prev_month_timestamp = (DateTime.now - 30).to_time.to_i
          contact = JSON.parse(contact_indexes_response, object_class: OpenStruct).data.find do |x|
            x.created_at > prev_month_timestamp && x.consent.status == 'accepted'
          end

          retry_count += 1
          contact
        end
      else
        raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
      end

      # Updating values
      @contact_id = contact.id
      @fname = contact.first_name
      @lname = contact.last_name
      @dob = contact.date_of_birth
      @dob_formatted = Time.at(@dob, in: '-05:00').strftime('%m/%d/%Y')
    end

    def add_consent
      consent_response = Requests::Consent.post_on_screen_consent(token: @token, group_id: @group_id,
                                                                  contact_id: @contact_id,
                                                                  signature_image: get_signature_image)
      expect(consent_response.status.to_s).to eq('200 OK')
    end

    def consent_token
      token = Requests::Consent.get_consent_token(token: @token, group_id: @group_id,
                                                  contact_id: @contact_id)
    end

    def request_consent_email(email:)
      consent_response = Requests::Consent.request_consent_via_email(
        token: @token, group_id: @group_id,
        contact_id: @contact_id,
        payload: { consents: { email_address: email } }
      )
      expect(consent_response.status.to_s).to eq('201 Created')
    end

    def add_phone_number(number:, phone_type: 'home', primary: true)
      @phone_number = Payloads::PhoneNumbers::Create.new(
        acceptable_communication_types: ['phone_call'],
        is_primary: primary,
        phone_number: number,
        phone_type: phone_type
      )

      phone_response = Requests::Contacts.add_phone_number(token: @token, group_id: @group_id,
                                                           contact_id: @contact_id,
                                                           payload: @phone_number)
      expect(phone_response.status.to_s).to eq('201 Created')
    end

    def add_address(**params)
      # Addresses need to be valid, defaulting to 56 Mott
      @address = Payloads::Addresses::Create.new(
        address_type: params[:address_type] || 'home',
        city: params[:city] || 'New York',
        country: params[:country] || 'USA',
        line_1: params[:line_1] || '56 Mott St',
        line_2: params[:line_2] || '',
        postal_code: params[:postal_code] || '10013',
        state: params[:state] || 'NY'
      ).to_h

      address_response = Requests::Contacts.add_address(token: @token, group_id: @group_id,
                                                        contact_id: @contact_id,
                                                        payload: { address: @address })

      expect(address_response.status.to_s).to eq('201 Created')
    end

    def add_email_address(email_address:, primary: false, notifications: false)
      @email_address = Payloads::Emails::Create.new(
        acceptable_communication_types: notifications ? %w[message notification] : [],
        is_primary: primary,
        email_address: email_address
      ).to_h

      email_response = Requests::Contacts.add_email(token: @token, group_id: @group_id,
                                                    contact_id: @contact_id, payload: @email_address)

      expect(email_response.status.to_s).to eq('201 Created')
    end

    def searchable_name
      "#{@fname} #{@lname}"
    end

    def formatted_address
      @address[:line_1] + ', ' + @address[:city] + ', ' + \
        @address[:state] + ' ' + @address[:postal_code]
    end

    def formatted_phone
      @phone_number.to_h[:phone_number][:phone_number]
    end

    def formatted_insurance
      @insurance[:insurance_id] + ' ' + @insurance[:insurance_type]
    end
  end
end
