require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_profile_page'
require_relative '../facesheet/pages/facesheet_overview_page'

describe '[Messaging - Facesheet - Preferences]', :app_client, :messaging do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:facesheet_profile) { Profile.new(@driver) }
  let(:facesheet_overview) { Overview.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      search_bar.search_for('UUQA Messaging')
      search_bar.go_to_facesheet_of('UUQA Messaging')
      facesheet_header.go_to_profile
    }

    it 'Add phone number and email for messaging', :uuqa_290, :uuqa_291 do
      facesheet_profile.switch_phone_preferences
      expect(facesheet_profile.get_error_message).to eql('Required')
      facesheet_profile.close_modal

      new_phone_number = base_page.number_to_phone_format(Faker::Number.number(digits: 10))
      facesheet_profile.add_phone_number(phone:new_phone_number , type:'Mobile')
      facesheet_profile.switch_phone_preferences

      expect(facesheet_profile.get_current_phone).to eql(new_phone_number)
      expect(facesheet_profile.get_current_phone_notifications).to eql('(message, notification)')

      facesheet_profile.switch_email_preferences
      expect(facesheet_profile.get_error_message).to eql('Required')
      facesheet_profile.close_modal

      new_email = Faker::Internet.email
      facesheet_profile.add_email(email:new_email)
      facesheet_profile.switch_email_preferences

      expect(facesheet_profile.get_current_email).to eql(new_email)
      expect(facesheet_profile.get_current_email_notifications).to eql('(message, notification)')
    end

    it 'Changing notification preferences registers in timeline', :uuqa_306 do
      new_phone_number = base_page.number_to_phone_format(Faker::Number.number(digits: 10))
      facesheet_profile.add_phone_number(phone:new_phone_number, type:'Mobile')
      facesheet_profile.switch_phone_preferences

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
