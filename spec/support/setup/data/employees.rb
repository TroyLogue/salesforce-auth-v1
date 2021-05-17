module Setup
  module Data
    def self.initialize_employee_with_role_and_program_in_qa_admin(logged_in_as:)
      # We want to avoid updating the employee that we are currently logged in as
      # Get all employees
      all_employees = Setup::Employees.get_all(token: JWTTokens::CC_QA_ADMIN,
                                               group_id: Providers::CC_QA_ADMIN)

      # Select random employee from list without logged_in_as employee
      employee = all_employees.reject { |e| e.attributes.email == logged_in_as }.sample

      role_ids = Setup::Roles.random_role_ids(token: JWTTokens::CC_QA_ADMIN, group_id: Providers::CC_QA_ADMIN)
      program_id = Setup::Programs.in_network_program_id(token: JWTTokens::CC_QA_ADMIN, group_id: Providers::CC_QA_ADMIN)

      request_roles = Setup::Employees.set_roles(
        token: JWTTokens::CC_QA_ADMIN,
        employee_id: employee.id,
        role_ids: role_ids
      )
      request_programs = Setup::Employees.set_programs(
        token: JWTTokens::CC_QA_ADMIN,
        employee_id: employee.id,
        program_ids: [program_id]
      )

      employee.id
    end
  end
end
