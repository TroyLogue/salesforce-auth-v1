require 'uniteus-api-client'
require 'faker'

require_relative '../../../../lib/file_helper'

module Setup
  # Object that represents a referral created by the user for a contact/client
  class CreateReferral
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_accessor :referral_id, :contact_id, :description, :referred_by_network_id, :referred_to_network_id,
                  :referred_to_groups, :service_type_id

    def initialize(**params)
      @contact_id = params[:contact_id] || -> { raise ArgumentError, 'Contact id required to create referral' }
      @referred_by_network_id = params[:referred_by_network_id] || -> { raise ArgumentError, 'Referred by network id required to create referral' }
      @referred_to_network_id = params[:referred_to_network_id] || -> { raise ArgumentError, 'Referred to network id required to create referral' }
      @referred_to_groups = params[:referred_to_groups] || []
      @service_type_id = params[:service_type_id] || -> { raise ArgumentError, 'Service type id required to create referral' }
      @referral_id = 0
      @description = Faker::Lorem.sentence(word_count: 5)
    end

    def create(token:, group_id:)
      request_body = Payloads::Referrals::Create.new({ description: @description,
                                                      referred_by_network_id: @referred_by_network_id,
                                                      referred_to_network_id: @referred_to_network_id,
                                                      referred_to_groups: @referred_to_groups,
                                                      service_type_id: @service_type_id })

      referral_response = Requests::Referrals.create(token: token, group_id: group_id, contact_id: @contact_id, referral: request_body)
      expect(referral_response.status.to_s).to eq('201 Created')
      @referral_id = JSON.parse(referral_response)['data'][0]['id']
    end
  end

  # Object that represents a referral accepted by the user (meaning the referral has already been created)
  class AcceptReferral
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    attr_accessor :primary_case_worker_id, :program_id, :referred_to, :service_type_id

    def initialize(**params)
      @primary_case_worker_id = params[:primary_case_worker_id] || -> { raise ArgumentError, 'Primary Worker Id required to accept referral' }
      @program_id = params[:program_id] || -> { raise ArgumentError, 'Program id required to accept referral' }
    end

    def accept_in_network(token:, group_id:, referral_id:)
      request_body = Payloads::Referrals::Accept.new({ entry_date: Time.now.to_i,
                                                      primary_case_worker_id: @primary_case_worker_id,
                                                      program_id: @program_id })

      accept_response = Requests::Referrals.accept(token: token, group_id: group_id, referral_id: referral_id, payload: request_body)
      expect(accept_response.status.to_s).to eq('200 OK')
    end
  end

  class CloseReferral
    include RSpec::Mocks::ExampleMethods::ExpectHost
    include RSpec::Matchers
    RESOLVED = 'ab4e4767-1e2f-4494-8b69-2e2cadf2312b'

    def close(token:, group_id:, referral_id:)
      closing = {
        note: 'Data cleanup',
        outcome_id: RESOLVED,
        resolved: true
      }
      close_response = Requests::Referrals.close(token: token, group_id: group_id, referral_id: referral_id, closing: closing)
      expect(close_response.status.to_s).to eq('200 OK')
    end
  end
end
