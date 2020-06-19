require_relative '../../base/referral'
require_relative '../../identifiers/group_ids'
require_relative '../../identifiers/network_ids'
require_relative '../../identifiers/primary_worker_ids'
require_relative '../../identifiers/program_ids'

# helper methods for referrals in the Ivy Network
module Setup
  module Data
    def send_referral_from_harvard_to_princeton(token:, contact_id:, service_type_id:)
      referral = CreateReferral.new({ contact_id: contact_id,
                                      referred_by_network_id: IVY_NETWORK,
                                      referred_to_network_id: IVY_NETWORK,
                                      referred_to_groups: [PRINCETON_GROUP],
                                      service_type_id: service_type_id })
      referral.create(token: token, group_id: HARVARD_GROUP)
      referral
    end

    def accept_referral_from_harvard_in_princeton(token:, referral_id:)
      referral = AcceptReferral.new({ primary_case_worker_id: PRINCETON_PRIMARY_WORKER,
                                      program_id: PRINCETON_PROGRAM })
      referral.accept_in_network(token: token, group_id: PRINCETON_GROUP, referral_id: referral_id)
      referral
    end
  end
end
