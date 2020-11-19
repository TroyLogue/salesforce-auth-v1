module Setup
  # UU3-49339 temp workaround for namespace conflict with setup/identifiers/programs
  class ProgramIds
    class << self
      def in_network_program_id(token:, group_id:)
        programs_response = Requests::Programs.get_all(token: token, group_id: group_id)
        parsed_programs_response = JSON.parse(programs_response, object_class: OpenStruct).data

        in_network_programs = parsed_programs_response.reject do |program|
          program.attributes[:name].include?('Referred Out of Network')
        end
        in_network_programs.first.id
      end
    end
  end
end
