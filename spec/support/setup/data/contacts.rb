require_relative '../base/contacts'
require_relative '../identifiers/group_ids'

# helper methods to create clients in the Ivy Network
module Setup
  module Data
    def self.create_harvard_client(token:)
      contact = Contact.new
      contact.create(token: token, group_id: HARVARD_GROUP)
      contact
    end

    def self.create_harvard_client_with_consent(token:)
      contact = Contact.new
      contact.create_with_consent(token: token, group_id: HARVARD_GROUP)
      contact
    end

    def self.create_princeton_client(token:)
      contact = Contact.new
      contact.create(token: token, group_id: PRINCETON_GROUP)
      contact
    end

    # Requires an existing Contact object
    def self.select_client_in_princeton(token:, contact:)
      contact.select(token: token, group_id: PRINCETON_GROUP)
      contact
    end
  end
end
