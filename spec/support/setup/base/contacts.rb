require 'uniteus-api-client'
require 'faker'

require_relative '../../../../lib/file_helper'

module Setup
  # An object that represents a contact/client created by a user in app-client
  class Contact
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_reader :fname, :lname, :dob_formatted, :military_affiliation_key
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
      get_consent_token
    end

    def create_with_military
      @military_affiliation_key = 'caregiver'
      military = Payloads::Military::Create.new(affiliation: military_affiliation_key)
      request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob, military: military.to_h })
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

    def add_consent
      consent_response = Requests::Consent.post_on_screen_consent(token: @token, group_id: @group_id,
                                                                  contact_id: @contact_id,
                                                                  signature_image: get_signature_image)
      expect(consent_response.status.to_s).to eq('200 OK')
    end

    def get_consent_token
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

    def searchable_name
      "#{@fname} #{@lname}"
    end

    def formatted_address
      @address[:line_1] + ' ' + @address[:line_2] + ' ' + @address[:city] + ' ' + @address[:postal_code]
    end

    def formatted_phone
      @phone_number.to_h[:phone_number][:phone_number]
    end

    def formatted_insurance
      @insurance[:insurance_id] + ' ' + @insurance[:insurance_type]
    end
  end
end
