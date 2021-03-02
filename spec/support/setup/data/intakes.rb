module Setup
  module Data
    def self.create_intake_for_harvard(contact_id:, fname:, lname:, dob:)
      Setup::Intakes.create(
        token: JWTTokens::CC_HARVARD,
        group_id: Providers::CC_HARVARD,
        contact_id: contact_id,
        contact_first_name: fname,
        contact_last_name: lname,
        contact_date_of_birth: dob
      )
    end

    def self.create_intake_for_yale(contact_id:, fname:, lname:, dob:)
      Setup::Intakes.create(
        token: JWTTokens::ORG_YALE,
        group_id: Providers::ORG_YALE,
        contact_id: contact_id,
        contact_first_name: fname,
        contact_last_name: lname,
        contact_date_of_birth: dob
      )
    end
  end
end
