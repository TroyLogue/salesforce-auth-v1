require_relative '../../base/contacts'
require_relative '../../identifiers/group_ids'
require_relative '../../identifiers/network_ids'

# helper methods to create clients in the Ivy Network
module Setup
  module Data
    def create_harvard_client(token:)
      contact = Contact.new
      contact.create(token: token, group_id: HARVARD_GROUP)
      contact
    end

    def create_harvard_client_with_consent(token:)
      contact = Contact.new
      contact.create_with_consent(token: token, group_id: HARVARD_GROUP)
      contact
    end
  end
end
