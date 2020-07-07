require_relative '../base/referrals'
require_relative '../identifiers/group_ids'
require_relative '../identifiers/network_ids'
require_relative '../identifiers/primary_worker_ids'
require_relative '../identifiers/program_ids'
require_relative '../identifiers/resolution_ids'

# helper methods for referrals in the Ivy Network
module Setup
  module Data
    def self.send_referral_from_harvard_to_princeton(token:, contact_id:, service_type_id:)
      referral = CreateReferral.new({ contact_id: contact_id,
                                      referred_by_network_id: IVY_NETWORK,
                                      referred_to_network_id: IVY_NETWORK,
                                      referred_to_groups: [PRINCETON_GROUP],
                                      service_type_id: service_type_id })
      referral.create(token: token, group_id: HARVARD_GROUP)
      referral
    end

    def self.accept_referral_from_harvard_in_princeton(token:, referral_id:)
      referral = AcceptReferral.new({ primary_case_worker_id: PRINCETON_PRIMARY_WORKER,
                                      program_id: PRINCETON_PROGRAM })
      referral.accept_in_network(token: token, group_id: PRINCETON_GROUP, referral_id: referral_id)
      referral
    end

    def self.send_referral_from_yale_to_harvard(token:, contact_id:, service_type_id:)
      referral = CreateReferral.new({ contact_id: contact_id,
                                      referred_by_network_id: IVY_NETWORK,
                                      referred_to_network_id: IVY_NETWORK,
                                      referred_to_groups: [HARVARD_GROUP],
                                      service_type_id: service_type_id })
      referral.create(token: token, group_id: YALE_GROUP)
      referral
    end

    def self.close_referral_from_yale_in_harvard(token:, referral_id:)
      referral = CloseReferral.new()
      referral.close(token: token, group_id: HARVARD_GROUP, referral_id: referral_id, resolution: RESOLVED)
      referral
    end
  end
end
