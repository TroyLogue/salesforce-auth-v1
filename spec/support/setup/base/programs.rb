module Setup
  class Programs
    class << self
      def in_network_program_id(token:, group_id:)
        programs_response = Core::Programs.get_all(token: token, group_id: group_id)
        parsed_programs_response = JSON.parse(programs_response.body, object_class: OpenStruct).data

        in_network_programs = parsed_programs_response.reject do |program|
          program.attributes[:name].include?('Referred Out of Network')
        end
        in_network_programs.first.id
      end
    end
  end
end
