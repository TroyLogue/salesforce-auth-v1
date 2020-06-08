require 'uniteus-api-client'
require 'faker'

require_relative '../../file_helper'

# An object that represents a contact/client created by a user in app-client
class Contact
  include RSpec::Mocks::ExampleMethods::ExpectHost
  include RSpec::Matchers
  attr_reader :fname, :lname, :dob
  attr_accessor :contact_id

  def initialize
    @fname = Faker::Name.first_name
    @lname = Faker::Name.last_name
    @dob = Requests::Contacts.random_dob
    @contact_id = 0
  end

  def create(token:, group_id:)
    request_body = Payloads::Contacts::Create.new({ first_name: @fname, last_name: @lname, date_of_birth: @dob })
    contact_response = Requests::Contacts.create(token: token, group_id: group_id, contact: request_body)

    expect(contact_response.status.to_s).to eq('201 Created')
    @contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
  end

  def create_with_consent(token:, group_id:)
    create(token: token, group_id: group_id)
    consent_response = Requests::Consent.post_on_screen_consent(token: token, group_id: group_id,
                                                                contact_id: @contact_id,
                                                                signature_image: get_signature_image)
    expect(consent_response.status.to_s).to eq('200 OK')
  end

  def searchable_name
    "#{@fname} #{@lname}"
  end
end
