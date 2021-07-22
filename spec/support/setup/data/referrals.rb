require_relative '../base/referrals'

# helper methods for referrals in the Ivy Network
module Setup
  module Data
    def self.send_referral_from_harvard_to_princeton(contact_id:)
      Referral.create(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [Providers::GENERAL_ORG_03],
        service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING
      )
    end

    def self.send_sensitive_referral_from_harvard_to_princeton(contact_id:)
      Referral.create(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [Providers::GENERAL_ORG_03],
        service_type_id: Services::DRUG_ALCOHOL_TESTING
      )
    end

    def self.send_referral_from_harvard_to_yale(contact_id:)
      Referral.create(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [Providers::GENERAL_ORG_01],
        service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING
      )
    end

    def self.reject_referral_in_harvard(note:)
      Referral.reject(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        note: note,
        reason: 'Client is not eligible for our services',
        reason_short: 'Not Eligible'
      )
    end

    def self.hold_referral_in_harvard(note:)
      Referral.hold(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        note: note,
        reason: 'Other'
      )
    end

    def self.accept_referral_in_princeton
      token = Auth.jwt(email_address: Users::ORG_03_USER)
      Referral.accept(
        token: token,
        group_id: Providers::GENERAL_ORG_03,
        primary_case_worker_id: PrimaryWorkers::ORG_03_USER,
        program_id: Setup::Programs.in_network_program_id(token: token, group_id: Providers::GENERAL_ORG_03)
      )
    end

    def self.send_referral_from_yale_to_harvard(contact_id:)
      Referral.create(
        token: Auth.jwt(email_address: Users::ORG_01_USER),
        group_id: Providers::GENERAL_ORG_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [Providers::GENERAL_CC_01],
        service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING
      )
    end

    def self.send_referral_from_yale_to_princeton(contact_id:)
      Referral.create(
        token: Auth.jwt(email_address: Users::ORG_01_USER),
        group_id: Providers::GENERAL_ORG_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [Providers::GENERAL_ORG_03],
        service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING
      )
    end

    def self.draft_referral_in_harvard(contact_id:)
      Referral.draft(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        contact_id: contact_id,
        referred_by_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_network_id: Networks::GENERAL_P2P_NETWORK,
        referred_to_groups: [],
        service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING
      )
    end

    def self.close_referral_in_harvard(note:)
      Referral.close(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        note: note,
        outcome_id: Resolutions::RESOLVED,
        resolved: true
      )
    end

    def self.recall_referral_in_princeton(note: 'Data Setup', reason: 'Client No Longer Requires Service')
      Referral.recall(
        token: Auth.jwt(email_address: Users::ORG_03_USER),
        group_id: Providers::GENERAL_ORG_03,
        note: note,
        reason: reason
      )
    end

    def self.reject_referral_in_princeton(note:)
      Referral.reject(
        token: Auth.jwt(email_address: Users::ORG_03_USER),
        group_id: Providers::GENERAL_ORG_03,
        note: note,
        reason: 'Client is not eligible for our services',
        reason_short: 'Not Eligible'
      )
    end

    def self.close_referral_in_princeton(note:)
      Referral.close(
        token: Auth.jwt(email_address: Users::ORG_03_USER),
        group_id: Providers::GENERAL_ORG_03,
        note: note,
        outcome_id: Resolutions::RESOLVED,
        resolved: true
      )
    end

    def self.hold_referral_in_princeton(note:)
      Referral.hold(
        token: Auth.jwt(email_address: Users::ORG_03_USER),
        group_id: Providers::GENERAL_ORG_03,
        note: note,
        reason: 'Other'
      )
    end

    def self.recall_referral_in_harvard(note: 'Data Setup', reason: 'Client No Longer Requires Service')
      Referral.recall(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        note: note,
        reason: reason
      )
    end

    # ASSESSMENTS
    def self.get_referral_form_name_for_yale(referral_id:)
      Setup::Forms.get_first_form_name_for_referral(
        token: Auth.jwt(email_address: Users::ORG_01_USER),
        group_id: Providers::GENERAL_ORG_01,
        referral_id: referral_id
      )
    end
  end
end
