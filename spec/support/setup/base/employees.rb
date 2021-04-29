module Setup
  class Employees
    class << self
      def get(token:, employee_id:)
        response = Core::Employees.get_employee(token: token, employee_id: employee_id)
        parsed_response = JSON.parse(response, object_class: OpenStruct).data
        parsed_response
      end
    end
  end
end
