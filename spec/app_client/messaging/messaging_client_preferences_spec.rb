require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../facesheet/pages/facesheet_profile_page'

describe '[Messaging - Facesheet - Preferences]', :app_client, :messaging do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_profile_page) { FacesheetProfilePage.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      expect(home_page.page_displayed?).to be_truthy

      # TODO - convert to creating client through endpoint - UU3-43972
      # Opted to navigate straight to facesheet, search fails at times
      # Test User: UUQA Testing Messaging
      base_page.get("/facesheet/dbd10ef7-bd7a-48ae-9217-334b09db480d/profile")
      expect(facesheet_profile_page.page_displayed?).to be_truthy
    }

    it 'Add phone number and email for messaging', :uuqa_290, :uuqa_291 do
      facesheet_profile_page.enable_phone_notifications_on_blank_field
      expect(facesheet_profile_page.is_required_error_message_displayed?).to be_truthy
      facesheet_profile_page.close_modal

      new_phone_number = base_page.number_to_phone_format(Faker::Number.number(digits: 10))
      facesheet_profile_page.add_mobile_phone_number_with_enabled_notifications(phone:new_phone_number)
      expect(facesheet_profile_page.get_current_phone_number).to eql(new_phone_number)
      expect(facesheet_profile_page.are_phone_notifications_enabled?).to be_truthy

      facesheet_profile_page.enable_email_notifications_on_blank_field
      expect(facesheet_profile_page.is_required_error_message_displayed?).to be_truthy
      facesheet_profile_page.close_modal

      new_email = Faker::Internet.email
      facesheet_profile_page.add_email_with_enabled_notifications(email:new_email)
      expect(facesheet_profile_page.get_current_email).to eql(new_email)
      expect(facesheet_profile_page.are_email_notifications_enabled?).to be_truthy
    end

    after {
      facesheet_profile_page.remove_profile_email_phone_fields_if_present
    }
  end
end
