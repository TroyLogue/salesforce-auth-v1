module Setup
  module Data
    def self.create_service_case_for_harvard(contact_id:)
      token = MachineTokens::CC_HARVARD
      group_id = Providers::CC_HARVARD

      Setup::Cases.create(
        token: token,
        network_id: Networks::IVY,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::Programs.in_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::CC_HARVARD,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end

    def self.close_service_case_for_harvard(contact_id:, case_id:, resolved: true)
      Setup::Cases.close(
        token: MachineTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        contact_id: contact_id,
        case_id: case_id,
        resolved: resolved
      )
    end

    def self.create_service_case_for_yale(contact_id:)
      token = MachineTokens::ORG_YALE
      group_id = Providers::ORG_YALE

      Setup::Cases.create(
        token: token,
        network_id: Networks::IVY,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::Programs.in_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::ORG_YALE,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end

    def self.close_service_case_for_yale(contact_id:, case_id:, resolved: true)
      Setup::Cases.close(
        token: MachineTokens::ORG_YALE,
        group_id: Providers::ORG_YALE,
        contact_id: contact_id,
        case_id: case_id,
        resolved: resolved
      )
    end

    def self.get_case_form_name_for_yale(contact_id:, case_id:)
      Setup::Forms.get_first_form_name_for_case(
        token: MachineTokens::ORG_YALE,
        group_id: Providers::ORG_YALE,
        contact_id: contact_id,
        case_id: case_id
      )
    end
  end
end
