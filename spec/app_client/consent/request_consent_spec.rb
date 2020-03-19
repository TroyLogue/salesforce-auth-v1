require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page.rb'
require_relative '../root/pages/left_nav.rb'
require_relative './pages/pending_consent_page.rb'

describe '[Consent - Request Consent]', :consent, :app_client do 
  include Login
  
  let(:base_page) { BasePage.new(@driver) }
  let(:dashboard) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:pending_consent_page) {PendingConsentPage.new(@driver) }

  context('[as cc user]') do 
    before {
      log_in_as(Login::CC_HARVARD) 
      left_nav.go_to_dashboard
      dashboard.go_to_pending_consent
      expect(pending_consent_page.page_displayed?).to be_truthy
    } 

    it 'adds consent to an incoming Pending Consent referral' do 
      @first_referral_text = pending_consent_page.text_of_first_referral;
      @second_referral_text = pending_consent_page.text_of_second_referral; 
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy
    end

    #it 'requests consent by email' do 
    #  skip
    #end

  end
end
