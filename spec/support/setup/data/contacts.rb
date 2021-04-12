require_relative '../base/contacts'
require_relative '../identifiers/provider_ids'
require_relative '../identifiers/jwt_tokens'

# helper methods to create clients in the Ivy Network
module Setup
  module Data
    def self.create_harvard_client
      contact = Contact.new(token: JWTTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact.create
      contact
    end

    def self.create_harvard_client_with_consent
      contact = Contact.new(token: JWTTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact.create_with_consent
      contact
    end

    def self.get_consent_token_for_new_harvard_client
      contact = Contact.new(token: MachineTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact.create_with_consent_token
    end

    def self.random_existing_harvard_client
      contact = Contact.new(token: JWTTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact.random_existing_client
      contact
    end

    def self.create_princeton_client
      contact = Contact.new(token: MachineTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact.create
    end

    def self.create_princeton_client
      contact = Contact.new(token: JWTTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact.create
      contact
    end

    def self.create_princeton_client_with_consent
      contact = Contact.new(token: JWTTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact.create_with_consent
      contact
    end

    # Requires an existing Contact object
    def self.select_client_in_princeton(contact:)
      contact.select(token: JWTTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact
    end

    def self.create_yale_client
      contact = Contact.new(token: JWTTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact.create
      contact
    end

    def self.create_yale_client_with_consent
      contact = Contact.new(token: JWTTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact.create_with_consent
      contact
    end

    def self.create_yale_client_with_military_and_consent
      contact = Contact.new(token: JWTTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact.create_with_military_and_consent
      contact
    end

    def self.create_columbia_client
      contact = Contact.new(token: JWTTokens::ORG_COLUMBIA, group_id: Providers::ORG_COLUMBIA)
      contact.create
      contact
    end

    def self.create_columbia_client_with_consent
      contact = Contact.new(token: JWTTokens::ORG_COLUMBIA, group_id: Providers::ORG_COLUMBIA)
      contact.create_with_consent
      contact
    end

    def self.enable_email_notifications_for_contact(contact:)
      contact.add_email_address(
        email_address: Faker::Internet.email,
        primary: true,
        notifications: true
      )
    end
  end
end
