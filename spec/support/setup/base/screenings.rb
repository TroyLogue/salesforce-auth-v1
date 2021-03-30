require 'uniteus-api-client'
require 'faker'

module Setup
  class Screenings
    class << self
      def create(token:, group_id:, contact_id:, form_id:, network_id:)
        form_response = Requests::Forms.get(token: token, group_id: group_id, contact_id: contact_id, form_id: form_id)
        expect(form_response.status.code).to eq 200

        parsed_form_response = JSON.parse(form_response, object_class: OpenStruct).data
        all_questions = parsed_form_response.sections.map(&:questions).flatten

        payload = Payloads::Screenings::Create.new(data: form_data(all_questions), network_id: network_id)

        response = Requests::Screenings.create(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          form_id: form_id,
          payload: payload
        )

        raise("Response returned: #{response.status}") unless response.status == 201

        JSON.parse(response, object_class: OpenStruct).data
      end
    end
  end
end
