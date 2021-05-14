module Setup
  class Employees
    class << self
      def get(token:, employee_id:)
        employee_response = Core::Employees.get_employee(token: token, employee_id: employee_id)

        raise("Response returned: #{employee_response.code}") unless employee_response.code == 200

        JSON.parse(employee_response.body, object_class: OpenStruct).data
      end

      def get_all(token:, group_id:)
        employee_response = Core::Employees.get_employees(token: token, group_id: group_id)

        raise("Response returned: #{employee_response.code}") unless employee_response.code == 200

        JSON.parse(employee_response.body, object_class: OpenStruct).data
      end

      def set_roles(token:, employee_id:, role_ids:)
        request_body = Payloads::Roles::Create.new(role_ids: role_ids)
        employee_response = Core::Employees.update_employee(token: token, employee_id: employee_id, payload: request_body.to_h)

        raise("Response returned: #{employee_response.code}") unless employee_response.code == 200

        JSON.parse(employee_response.body, object_class: OpenStruct)
      end

      def set_programs(token:, employee_id:, program_ids:)
        request_body = Payloads::Programs::Create.new(program_ids: program_ids)
        employee_response = Core::Employees.update_employee(token: token, employee_id: employee_id, payload: request_body.to_h)

        raise("Response returned: #{employee_response.code}") unless employee_response.code == 200

        JSON.parse(employee_response.body, object_class: OpenStruct)
      end
    end
  end
end
