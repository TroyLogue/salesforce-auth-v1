require_relative '../base/referrals'
require_relative '../identifiers/provider_ids'
require_relative '../identifiers/network_ids'
require_relative '../identifiers/primary_worker_ids'
require_relative '../identifiers/program_ids'
require_relative '../identifiers/resolution_ids'
require_relative '../identifiers/service_types_ids'
require_relative '../identifiers/machine_tokens'

# helper methods for referrals in the Ivy Network
module Setup
  module Data
    def self.send_referral_from_harvard_to_princeton(contact_id:)
      referral = CreateReferral.new({ contact_id: contact_id,
                                      referred_by_network_id: IVY_NETWORK,
                                      referred_to_network_id: IVY_NETWORK,
                                      referred_to_groups: [Providers::ORG_PRINCETON],
                                      service_type_id: BENEFITS_DISABILITY_BENEFITS })
      referral.create(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD
      )
      referral
    end

    def self.accept_referral_from_harvard_in_princeton(referral_id:)
      referral = AcceptReferral.new({ primary_case_worker_id: PrimaryWorkers::ORG_PRINCETON,
                                      program_id: Programs::ORG_PRINCETON })
      referral.accept_in_network(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        referral_id: referral_id
      )
      referral
    end

    def self.send_referral_from_yale_to_harvard(contact_id:)
      referral = CreateReferral.new({ contact_id: contact_id,
                                      referred_by_network_id: IVY_NETWORK,
                                      referred_to_network_id: IVY_NETWORK,
                                      referred_to_groups: [Providers::CC_HARVARD],
                                      service_type_id: BENEFITS_DISABILITY_BENEFITS })
      referral.create(
        token: MachineTokens::ORG_YALE,
        group_id: Providers::ORG_YALE
      )
      referral
    end

    def self.close_referral_from_yale_in_harvard(referral_id:)
      referral = CloseReferral.new
      referral.close(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        referral_id: referral_id,
        resolution: RESOLVED
      )
      referral
    end

    def self.recall_referral_in_princeton(referral_id:, note:)
      referral = RecallReferral.new({ recall_note: note,
                                      reason: 'Client No Longer Requires Service' })
      referral.recall_referral(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        referral_id: referral_id
      )
    end
  end
end
