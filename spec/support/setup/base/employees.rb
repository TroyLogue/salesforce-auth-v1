module Setup
  class Employees
    class << self
      def get(token:, employee_id:)
        response = Core::Employees.get_employee(token: token, employee_id: employee_id)
        parsed_response = JSON.parse(response, object_class: OpenStruct).data
        parsed_response
      end

      def provider_id(token:, employee_id:)
        parsed_response = get(token: token, employee_id: employee_id)
        provider_id = parsed_response.relationships.provider.data.id
        p "provider_id: #{provider_id}"
        provider_id
      end
    end
  end
end
