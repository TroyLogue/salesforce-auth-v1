require 'uniteus-api-client'
require 'faker'

require_relative '../../../../lib/file_helper'

module Setup
  # An object that represents a Assistance request created by a user in app-client
  class AssistanceRequest
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_accessor :ar_id
    attr_reader :access_token, :service_type_id, :description, :first_name,
                :last_name, :middle_name_initial, :date_of_birth, :email_address,
                :gender, :race, :ethnicity, :ssn,
                :gross_monthly_income, :citizenship, :form_id, :signature_image

    def initialize
      @ar_id = 0  
      @description = Faker::Lorem.sentence(word_count: 5)
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @middle_name_initial = Faker::Name.initials(number: 1)
      @date_of_birth = Requests::Contacts.random_dob
      @email_address = Faker::Internet.email
      @signature_image = get_signature_image
    end

    def create(access_token:, service_type_id:)
      ar_request_body = Payloads::AssistanceRequest::Create.new({ first_name: @fname,
                                                                  last_name: @lname,
                                                                  middle_name_initial: @middle_name_initial,
                                                                  date_of_birth: @date_of_birth,
                                                                  description: @description,
                                                                  email_address: @email_address,
                                                                  service_type_id: service_type_id,
                                                                  signature_image: @signature_image,
                                                                  access_token: access_token
                                                                })
      ar_response = Requests::AssistanceRequest.create(payload: ar_request_body)
      expect(ar_response.status.to_s).to eq('201 Created')
      @ar_data = JSON.parse(ar_response, object_class: OpenStruct).data
    end
  end

  class CloseAssistanceRequest
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    
    def close(token:, group_id:, contact_id:, resolution:)
      payload = {
        closing:{
          outcome_id: resolution,
          resolved: 'resolved',
          note: 'Data cleanup'
        }
      }
      close_response = Requests::AssistanceRequest.close(token: token, group_id: group_id, contact_id: contact_id, payload: payload)
      expect(close_response.status.to_s).to eq('200 OK')
    end
  end
end
