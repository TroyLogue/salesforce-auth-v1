require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_profile_page'
require_relative '../clients/pages/clients_page'

describe '[Messaging]', :app_client, :messaging do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:facesheet_profile) { Profile.new(@driver)}

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
      facesheet_header.go_to_profile
    } 

    it 'Add phone number for messaging', :uuqa_290 do
      facesheet_profile.add_phone_number(phone:Faker::PhoneNumber.cell_phone, type:'Mobile')
      facesheet_profile.switch_phone_preferences
    end
  end
end
