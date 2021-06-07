# frozen_string_literal: true

require_relative '../cases/pages/case'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[Cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as an employee with Out of Network user role]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @case = Setup::Data.create_oon_case_for_harvard(contact_id: @contact.contact_id)

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

     it 'can edit the referred-to values for an open OON case', :uuqa_1817 do
      case_detail_page.go_to_open_case_with_id(case_id: @case.id, contact_id: @contact.contact_id)
      expect(case_detail_page.page_displayed?).to be_truthy
      initial_referred_to = case_detail_page.referred_to

      new_oon_recipient = case_detail_page.add_random_oon_recipient
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_UPDATED)

      new_custom_recipient = Faker::String.random(length: 10)
      case_detail_page.add_custom_recipient(custom_recipient: new_custom_recipient)
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_UPDATED)

      expect(case_detail_page.referred_to_array).to eq([initial_referred_to, new_oon_recipient, new_custom_recipient])
    end
  end
end
