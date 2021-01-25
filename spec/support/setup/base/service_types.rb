module Setup
  class ServiceTypes
    class << self
      # takes a parent service type code and returns the ID
      # not compatible with child service types
      def service_type_id(token:, network_id:, service_type_code:)
        service_types_response = Requests::Networks.get_service_types(token: token, network_id: network_id)

        parsed_service_types_response = JSON.parse(service_types_response, object_class: OpenStruct)
        parsed_service_types_response.data.map do |t1|
          t1.id if t1.code == service_type_code
        end.compact.first
      end
    end
  end
end
