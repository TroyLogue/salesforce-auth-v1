require 'uniteus-api-client'
require 'faker'

require_relative '../../../../lib/file_helper'

module Setup
  # An object that represents a contact/client created by a user in app-client
  class Contact
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_reader :fname, :lname, :dob_formatted, :military_affiliation_key
    attr_accessor :contact_id

    def initialize
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Requests::Contacts.random_dob
      @dob_formatted = Time.at(@dob).strftime('%m/%d/%Y')
      @addresses = []
      @phones = []
      @insurance = []
      @contact_id = 0
    end

    def create(token:, group_id:)
      request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob })
      contact_response = Requests::Contacts.create(token: token, group_id: group_id, contact: request_body)

      expect(contact_response.status.to_s).to eq('201 Created')
      @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
    end

    def create_with_military(token:, group_id:)
      @military_affiliation_key = 'caregiver'
      military = Payloads::Military::Create.new(affiliation: military_affiliation_key)
      request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob, military: military.to_h })
      contact_response = Requests::Contacts.create(token: token, group_id: group_id, contact: request_body)

      expect(contact_response.status.to_s).to eq('201 Created')
      @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
    end

    def create_with_consent(token:, group_id:)
      create(token: token, group_id: group_id)
      consent_response = Requests::Consent.post_on_screen_consent(token: token, group_id: group_id,
                                                                  contact_id: @contact_id,
                                                                  signature_image: get_signature_image)
      expect(consent_response.status.to_s).to eq('200 OK')
    end

    def select(token:, group_id:)
      contact_response = Requests::Contacts.search_and_select(token: token, group_id: group_id,
                                                              contact_id: @contact_id)
      expect(contact_response.status.to_s).to eq('200 OK')
    end

    def create_with_military_and_consent(token:, group_id:)
      create_with_military(token: token, group_id: group_id)
      consent_response = Requests::Consent.post_on_screen_consent(token: token, group_id: group_id,
                                                                  contact_id: @contact_id,
                                                                  signature_image: get_signature_image)
      expect(consent_response.status.to_s).to eq('200 OK')
    end

    def create_with_all_fields(token:, group_id:)
      @military_affiliation_key = 'caregiver'

      # creating military payload, pre-set values
      @military = Payloads::Military::Create.new(affiliation: military_affiliation_key).to_h

      # creating address payload, pre-set values
      @address = Payloads::Addresses::Create.new(address_type: 'home',
                                                 city: Payloads::Addresses::Create::CITY_FOR_PERMISSIBLE_CLIENT,
                                                 line_1: Payloads::Addresses::Create::LINE_1_FOR_PERMISSIBLE_CLIENT,
                                                 postal_code: Payloads::Addresses::Create::POST_CODE_FOR_PERMISSIBLE_CLIENT,
                                                 state: 'NY').to_h

      # creating insurance payload, pre-set values
      @insurance = Payloads::Insurance::Create.new(insurance_id: '1EG4-TE5-MK73', insurance_type: 'medicare').to_h

      # creating contact payload
      request_body = Payloads::Contacts::Create.new({ first_name: @fname,
                                                      last_name: @lname,
                                                      date_of_birth: @dob,
                                                      addresses: [@address],
                                                      insurance_ids: [@insurance],
                                                      military: @military })

      contact_response = Requests::Contacts.create(token: token, group_id: group_id, contact: request_body)
      expect(contact_response.status.to_s).to eq('201 Created')
      @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id

      # creating phone number payload with pre-set values
      @phone_number = Payloads::PhoneNumbers::Create.new(acceptable_communication_types: ['phone_call'],
                                                         is_primary: true,
                                                         phone_number: '(123) 123-1231 x 23123',
                                                         phone_type: 'work')

      phone_response = Requests::Contacts.add_phone_number(token:token, group_id: group_id, contact_id: @contact_id, payload: @phone_number)
      expect(phone_response.status.to_s).to eq('201 Created')

      # Adding consent
      consent_response = Requests::Consent.post_on_screen_consent(token: token, group_id: group_id,
                                                                  contact_id: @contact_id,
                                                                  signature_image: get_signature_image)
      expect(consent_response.status.to_s).to eq('200 OK')
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
