require_relative '../base/contacts'
require_relative '../identifiers/provider_ids'
require_relative '../identifiers/machine_tokens'

# helper methods to create clients in the Ivy Network
module Setup
  module Data
    def self.create_harvard_client
      contact = Contact.new
      contact.create(token: MachineTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact
    end

    def self.create_harvard_client_with_consent
      contact = Contact.new
      contact.create_with_consent(token: MachineTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact
    end

    def self.create_harvard_client_with_all_fields
      contact = Contact.new
      contact.create_with_all_fields(token: MachineTokens::CC_HARVARD, group_id: Providers::CC_HARVARD)
      contact
    end

    def self.create_princeton_client
      contact = Contact.new
      contact.create(token: MachineTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact
    end

    # Requires an existing Contact object
    def self.select_client_in_princeton(contact:)
      contact.select(token: MachineTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact
    end

    def self.create_princeton_client_with_consent
      contact = Contact.new
      contact.create_with_consent(token: MachineTokens::ORG_PRINCETON, group_id: Providers::ORG_PRINCETON)
      contact
    end

    def self.create_yale_client
      contact = Contact.new
      contact.create(token: MachineTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact
    end

    def self.create_yale_client_with_consent
      contact = Contact.new
      contact.create_with_consent(token: MachineTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact
    end

    def self.create_yale_client_with_military_and_consent
      contact = Contact.new
      contact.create_with_military_and_consent(token: MachineTokens::ORG_YALE, group_id: Providers::ORG_YALE)
      contact
    end

    def self.create_columbia_client_with_consent
      contact = Contact.new
      contact.create_with_consent(token: MachineTokens::ORG_COLUMBIA, group_id: Providers::ORG_COLUMBIA)
      contact
    end

    def self.create_columbia_client_with_all_fields
      contact = Contact.new
      contact.create_with_all_fields(token: MachineTokens::ORG_COLUMBIA, group_id: Providers::ORG_COLUMBIA)
      contact
    end
  end
end
