module Setup
  module Data
    def self.create_service_case_for_harvard(contact_id:)
      token = Auth.jwt(email_address: Users::CC_01_USER)
      group_id = Providers::GENERAL_CC_01

      Setup::Cases.create(
        token: token,
        network_id: Networks::GENERAL_P2P_NETWORK,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::Programs.in_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::CC_01_USER,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end

    def self.create_oon_case_for_harvard(contact_id:)
      token = Auth.jwt(email_address: Users::CC_01_USER)
      group_id = Providers::GENERAL_CC_01
      custom_name = Faker::Lorem.word

      Setup::Cases.create(
        token: token,
        network_id: Networks::GENERAL_P2P_NETWORK,
        group_id: group_id,
        contact_id: contact_id,
        out_of_network_providers: [{ provider_id: nil, provider_type: "CUSTOM", custom_name: custom_name }],
        program_id: Setup::Programs.out_of_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::CC_01_USER,
        referred_to: custom_name,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end

    def self.close_service_case_for_harvard(contact_id:, case_id:, resolved: true)
      Setup::Cases.close(
        token: Auth.jwt(email_address: Users::CC_01_USER),
        group_id: Providers::GENERAL_CC_01,
        contact_id: contact_id,
        case_id: case_id,
        resolved: resolved
      )
    end

    def self.create_service_case_for_payments(contact_id:)
      token = Auth.jwt(email_address: Users::ORG_PAYMENTS_USER)
      group_id = Providers::PAYMENTS_ORG

      Setup::Cases.create(
        token: token,
        network_id: Networks::PAYMENTS_NETWORK,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::Programs.program_with_name(token: token, group_id: group_id,
                                                      program_name: ProgramNames::PROGRAM_WITH_FEE_SCHEDULE),
        primary_worker_id: PrimaryWorkers::PAYMENTS_USER,
        service_type_code: ServiceTypeCodes::TRANSPORTATION
      )
    end

    def self.create_service_case_for_yale(contact_id:)
      token = Auth.jwt(email_address: Users::ORG_01_USER)
      group_id = Providers::GENERAL_ORG_01

      Setup::Cases.create(
        token: token,
        network_id: Networks::GENERAL_P2P_NETWORK,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::Programs.in_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::ORG_01_USER,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end

    def self.close_service_case_for_yale(contact_id:, case_id:, resolved: true)
      Setup::Cases.close(
        token: Auth.jwt(email_address: Users::ORG_01_USER),
        group_id: Providers::GENERAL_ORG_01,
        contact_id: contact_id,
        case_id: case_id,
        resolved: resolved
      )
    end

    # ASSESSMENTS
    def self.get_case_form_name_for_yale(contact_id:, case_id:)
      Setup::Forms.get_first_form_name_for_case(
        token: Auth.jwt(email_address: Users::ORG_01_USER),
        group_id: Providers::GENERAL_ORG_01,
        contact_id: contact_id,
        case_id: case_id
      )
    end
  end
end
