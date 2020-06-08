require_relative '../base/setup_contacts'
require_relative '../test_data/group_ids'
require_relative '../test_data/network_ids'

# helper methods to create clients in the Ivy Network
module IvyNetworkClients
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
