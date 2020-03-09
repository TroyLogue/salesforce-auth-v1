require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page.rb'
# require_relative './pages/assistance_requests' Not written yet

describe '[Consent - Request Consent]', :consent, :app_client do 
  include Login
  
  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }

  context('[as cc user]') do 
    before {
      log_in_as(Login::CC_HARVARD)
    } 

    it 'uploads consent form to assistance request' do 
      # not working yet
      base_page.get('/dashboard/new/pending-consent')
      home_page.open_consent_modal
    end

    # need this? mailtrap... 
    it 'requests and grants consent by email' do 
      skip
    end

  end
end
