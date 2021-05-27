module Setup
  module Data
    def self.initialize_employee_with_role_and_program_in_qa_admin(current_user_email_address:)
      # We want to avoid updating the employee that we are currently logged in as
      # Get all employees
      @cc_qa_admin_token = Auth.jwt(email_address: Users::CC_QA_ADMIN)
      all_employees = Setup::Employees.get_all(token: @cc_qa_admin_token,
                                               group_id: Providers::CC_QA_ADMIN)

      # Select random employee from list without current_user_email_address employee
      employee = all_employees.reject { |e| e.attributes.email == current_user_email_address }.sample

      role_ids = Setup::Roles.random_role_ids(token: @cc_qa_admin_token, group_id: Providers::CC_QA_ADMIN)
      program_id = Setup::Programs.in_network_program_id(token: @cc_qa_admin_token, group_id: Providers::CC_QA_ADMIN)

      request_roles = Setup::Employees.set_roles(
        token: @cc_qa_admin_token,
        employee_id: employee.id,
        role_ids: role_ids
      )
      request_programs = Setup::Employees.set_programs(
        token: @cc_qa_admin_token,
        employee_id: employee.id,
        program_ids: [program_id]
      )

      employee.id
    end
  end
end
