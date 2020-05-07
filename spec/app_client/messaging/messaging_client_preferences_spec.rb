require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_profile_page'
require_relative '../facesheet/pages/facesheet_overview_page'
require_relative '../clients/pages/clients_page'

describe '[Messaging - Facesheet - Preferrences]', :app_client, :messaging do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:facesheet_profile) { Profile.new(@driver) }
  let(:facesheet_overview) { Overview.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
      facesheet_header.go_to_profile
    } 

    it 'Add phone number and email for messaging', :uuqa_290, :uuqa_291 do
      facesheet_profile.switch_phone_preferrences
      expect(facesheet_profile.get_error_message).to eql('Required')
      facesheet_profile.close_modal

      facesheet_profile.add_phone_number(phone:Faker::PhoneNumber.cell_phone, type:'Mobile')
      facesheet_profile.switch_phone_preferrences

      facesheet_profile.switch_email_preferrences
      expect(facesheet_profile.get_error_message).to eql('Required')
      facesheet_profile.close_modal

      facesheet_profile.add_email(email:Faker::Internet.email)
      facesheet_profile.switch_email_preferrences
    end

    it 'Changing allowing notifications registers in timeline', :uuqa_306 do
      #Formatting used to display numbers => (999) 999-9999  
      new_phone_number = "(#{Faker::Number.number(digits:3)}) #{Faker::Number.number(digits:3)}-#{Faker::Number.number(digits:4)}"
      facesheet_profile.add_phone_number(phone:new_phone_number, type:'Mobile')
      facesheet_profile.switch_phone_preferrences

      facesheet_header.go_to_overview
      expect(facesheet_overview.first_entry_in_timeline).to \
      include("Notifications were enabled for #{facesheet_header.get_facesheet_name} at\n#{new_phone_number}\nby Columbia Ivy")
    end

    after { 
      facesheet_header.go_to_profile
      facesheet_profile.remove_phone_number
      facesheet_profile.remove_email
    }

  end
end
