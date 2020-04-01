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

    it 'adds consent to an incoming Pending Consent referral' do 
      home_page.go_to_pending_consent
      @first_referral_text = pending_consent_page.text_of_first_referral;
      @second_referral_text = pending_consent_page.text_of_second_referral; 
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      consent_modal.add_on_screen_consent 

      expect(pending_consent_page.consent_modal_not_displayed?).to be_truthy

      # confirm the referral we added consent to 
      # is removed from the pending consent page on refresh
      base_page.refresh
      expect(pending_consent_page.page_displayed?).to be_truthy 
      pp "refreshed page and page is displayed again"

      @new_first_referral_text = pending_consent_page.text_of_first_referral
      expect(@new_first_referral_text).to eq(@second_referral_text)
    end

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
