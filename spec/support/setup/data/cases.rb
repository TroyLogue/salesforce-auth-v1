module Setup
  module Data
    def self.create_service_case_for_harvard(contact_id:)
      token = MachineTokens::CC_HARVARD
      group_id = Providers::CC_HARVARD

      Setup::Cases.create(
        token: token,
        network_id: IVY_NETWORK,
        group_id: group_id,
        contact_id: contact_id,
        program_id: Setup::ProgramIds.in_network_program_id(token: token, group_id: group_id),
        primary_worker_id: PrimaryWorkers::CC_HARVARD,
        service_type_code: ServiceTypeCodes::EMPLOYMENT
      )
    end
  end
end
