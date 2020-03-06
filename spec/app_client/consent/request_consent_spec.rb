require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
# require_relative './pages/assistance_requests' Not written yet

describe '[Consent - Request Consent]', :consent, :app_client do 
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }

  context('[as cc user]') do 
    before {
      log_in_as(Login::CC_HARVARD)
    } 

    it 'uploads consent form' do 
      base_page.get('/dashboard/new/pending-consent')
             
    end

    # need this? mailtrap... 
    it 'requests and grants consent by email' do 
      skip
    end

  end
end
