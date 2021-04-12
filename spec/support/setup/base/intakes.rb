require 'uniteus-api-client'
require 'faker'

module Setup
  class Intakes
    class << self
      def create(token:, group_id:, contact_id:, **params)
        request_body = Payloads::Intakes::Create.new(
          {
            contact_first_name: params[:contact_first_name],
            contact_last_name: params[:contact_last_name],
            contact_date_of_birth: params[:contact_date_of_birth],
            originator_id: params[:originator_id],
            originator_type: params[:originator_type]
          }
        )

        response = Requests::Intakes.create(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          payload: request_body
        )

        raise("Response returned: #{response.status}") unless response.status == 201

        JSON.parse(response, object_class: OpenStruct).data
      end
    end
  end
end
