module Setup
  module Data
    def self.create_screening_for_harvard_contact(contact_id:)

      screening_id = Setup::Data.get_first_screening_id_for_harvard;

      Setup::Screenings.create(
        token: Auth.access_token(email_address: Users::CC_USER),
        group_id: Providers::CC_HARVARD,
        contact_id: contact_id,
        form_id: screening_id,
        network_id: Networks::IVY
      )
    end

    def self.get_first_screening_id_for_harvard
      Setup::Forms.get_first_screening_id_for_provider(
        token: Auth.access_token(email_address: Users::CC_USER),
        group_id: Providers::CC_HARVARD,
        network_id: Networks::IVY
      )
    end
  end
end
