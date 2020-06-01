require 'uniteus-api-client'
require 'faker'

require_relative '../lib/file_helper'

module Setup
  class Referral
    attr_accessor :referral_id, :contact_id, :description, :referred_by_network_id, :referred_to_network_id, :referred_to_groups, :service_type_id

    def initialize(**params)
      @contact_id = params[:contact_id] || -> { raise ArgumentError.new 'Contact id required to create referral' }
      @referral_id = 0
      @description = Faker::Lorem.sentence(word_count: 5)
      @referred_by_network_id = params[:referred_by_network_id] || -> { raise ArgumentError.new 'Referred by network id required to create referral' }
      @referred_to_network_id = params[:referred_to_network_id] || -> { raise ArgumentError.new 'Referred to network id required to create referral' }
      @referred_to_groups = params[:referred_to_groups] || []
      @service_type_id = params[:service_type_id] || -> { raise ArgumentError.new 'Service type id required to create referral' }
    end

    def create(token:, group_id:)
      request_body = Payloads::Referrals::Create.new({description: @description,
                                                      referred_by_network_id: @referred_by_network_id,
                                                      referred_to_network_id: @referred_to_network_id,
                                                      referred_to_groups: @referred_to_groups,
                                                      service_type_id: @service_type_id})

      contact_response = Requests::Referrals.create(token: token, group_id: group_id, contact_id: @contact_id, referral: request_body)
    end
  end
end
