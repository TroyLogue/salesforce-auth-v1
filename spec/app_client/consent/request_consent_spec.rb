require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative './pages/consent_modal'
require_relative './pages/pending_consent_page'

describe '[Consent - Request Consent]', :consent, :app_client do 
  include Login
  
  let(:base_page) { BasePage.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:pending_consent_page) {PendingConsentPage.new(@driver) }

  context('[as cc user]') do 
    before {
      log_in_as(Login::CC_HARVARD) 
      expect(home_page.page_displayed?).to be_truthy
    } 

    it 'requests consent by email' do 
      home_page.go_to_pending_consent
      expect(pending_consent_page.page_displayed?).to be_truthy

      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      address = "#{Faker::Internet.email}"
      consent_modal.request_consent_by_email(address)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CONSENT_REQUEST_SENT)
    end

  end
end
