module Setup
  class Cases
    class << self
      def create(
        token:,
        network_id:,
        group_id:,
        contact_id:,
        program_id:,
        primary_worker_id:,
        service_type_code:,
        referred_to: nil,
        description: Faker::Lorem.sentence,
        out_of_network_providers: []
      )

        service_case_payload = Payloads::Cases::Create.new(
          network_id: network_id,
          entry_date: (DateTime.now - 1).to_time.to_i,
          program_id: program_id,
          referred_to: referred_to,
          description: description,
          out_of_network_providers: out_of_network_providers,
          primary_worker_id: primary_worker_id,
          service_type_id: Setup::ServiceTypes.service_type_id(
            token: token,
            network_id: network_id,
            service_type_code: service_type_code
          )
        )

        service_case_response = Requests::Cases.create(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          payload: service_case_payload
        )

        raise("Response returned: #{service_case_response.status}") unless service_case_response.status == 201

        JSON.parse(service_case_response, object_class: OpenStruct).data
      end

      def close(
        token:,
        group_id:,
        contact_id:,
        case_id:,
        resolved:
      )
        close_case_payload = {
          closing: {
            exited_at: DateTime.now.to_time.to_i,
            note: Faker::Lorem.sentence,
            outcome_id: resolved ? Resolutions::RESOLVED : Resolutions::UNRESOLVED,
            resolved: resolved
          }
        }

        closed_case_response = Requests::Cases.close(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          case_id: case_id,
          payload: close_case_payload
        )

        raise("Response returned: #{closed_case_response.status}") unless closed_case_response.status == 200

        JSON.parse(closed_case_response, object_class: OpenStruct).data
      end
    end
  end
end
