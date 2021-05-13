module Setup
  class Roles
    class << self
      def random_role_ids(token:, group_id:)
        roles_response = Core::Roles.get(token: token, group_id: group_id)

        raise("Response returned: #{roles_response.code}") unless roles_response.code == 200

        parsed_roles_response = JSON.parse(roles_response.body, object_class: OpenStruct).data

        org_role_names = ['Network Access User',
                          'Assistance Requests User',
                          'Insurance User',
                          'Intakes User',
                          'Payments User',
                          'Referrals Admin User',
                          'Referrals User',
                          'Screening User',
                          'Network Directory User',
                          'Exports User',
                          'Out of Network Cases User',
                          'Organization Administrator'].sample(3)

        program_role_name = ['Supervisor', 'Case Manager', 'General Staff'].sample

        role_ids = []
        (org_role_names << program_role_name).each do |name|
          role_id = parsed_roles_response.map do |r|
            r.id if r.attributes.name == name
          end .compact.first
          role_ids << role_id
        end
        role_ids
      end
    end
  end
end
