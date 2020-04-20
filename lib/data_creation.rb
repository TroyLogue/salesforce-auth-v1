require 'api-integration'
require 'faker'

module DataCreation
    class Contact    
        def initialize()
            @fname = Faker::Name.first_name
            @lname = Faker::Name.last_name
            @dob = Requests::Contacts.random_dob
            @contact = Models::Contact.new({first_name: @fname, last_name: @lname, date_of_birth: @dob })
            @contact.to_h
        end
  
        def create(token:, group_id:)
            contact_response = Requests::Contacts.post(token: token, group_id: group_id, contact: @contact)
        end

        def formatted_name
            "#{lname}, #{fname}"
        end

    end
end
