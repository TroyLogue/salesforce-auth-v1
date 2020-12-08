require_relative '../base/referrals'

# helper methods for referrals in the Ivy Network
module Setup
  module Data
    def self.send_referral_from_harvard_to_princeton(contact_id:)
      Referral.create(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        contact_id: contact_id,
        referred_by_network_id: Networks::IVY,
        referred_to_network_id: Networks::IVY,
        referred_to_groups: [Providers::ORG_PRINCETON],
        service_type_id: Services::BENEFITS_DISABILITY_BENEFITS
      )
    end

    def self.send_referral_from_harvard_to_yale(contact_id:)
      Referral.create(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        contact_id: contact_id,
        referred_by_network_id: Networks::IVY,
        referred_to_network_id: Networks::IVY,
        referred_to_groups: [Providers::ORG_YALE],
        service_type_id: Services::BENEFITS_DISABILITY_BENEFITS
      )
    end

    def self.reject_referral_in_harvard(note:)
      Referral.reject(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        note: note,
        reason: 'Client is not eligible for our services',
        reason_short: 'Not Eligible'
      )
    end

    def self.accept_referral_in_princeton
      Referral.accept(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        primary_case_worker_id: PrimaryWorkers::ORG_PRINCETON,
        program_id: Programs::ORG_PRINCETON
      )
    end

    def self.send_referral_from_yale_to_harvard(contact_id:)
      Referral.create(
        token: MachineTokens::ORG_YALE,
        group_id: Providers::ORG_YALE,
        contact_id: contact_id,
        referred_by_network_id: Networks::IVY,
        referred_to_network_id: Networks::IVY,
        referred_to_groups: [Providers::CC_HARVARD],
        service_type_id: Services::BENEFITS_DISABILITY_BENEFITS
      )
    end

    def self.send_referral_from_yale_to_princeton(contact_id:)
      Referral.create(
        token: MachineTokens::ORG_YALE,
        group_id: Providers::ORG_YALE,
        contact_id: contact_id,
        referred_by_network_id: Networks::IVY,
        referred_to_network_id: Networks::IVY,
        referred_to_groups: [Providers::ORG_PRINCETON],
        service_type_id: Services::BENEFITS_DISABILITY_BENEFITS
      )
    end

    def self.close_referral_in_harvard(note:)
      Referral.close(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        note: note,
        outcome_id: Resolutions::RESOLVED,
        resolved: true
      )
    end

    def self.recall_referral_in_princeton(note: 'Data Setup', reason: 'Client No Longer Requires Service')
      Referral.recall(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        note: note,
        reason: reason
      )
    end

    def self.reject_referral_in_princeton(note:)
      Referral.reject(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        note: note,
        reason: 'Client is not eligible for our services',
        reason_short: 'Not Eligible'
      )
    end

    def self.close_referral_in_princeton(note:)
      Referral.close(
        token: MachineTokens::ORG_PRINCETON,
        group_id: Providers::ORG_PRINCETON,
        note: note,
        outcome_id: Resolutions::RESOLVED,
        resolved: true
      )
    end

    def self.recall_referral_in_harvard(note: 'Data Setup', reason: 'Client No Longer Requires Service')
      Referral.recall(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        note: note,
        reason: reason
      )
    end
  end
end
