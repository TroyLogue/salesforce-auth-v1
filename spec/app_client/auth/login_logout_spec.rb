require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative './pages/network_browse_map'

describe '[Auth - Login and Logout]', :app_client, :auth, :login do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }

  it 'Logs in with a valid email, then logs out' do 
    log_in_as(CC_HARVARD)
    # expect home page is displayed
    # log out
  end

  it 'Prevents login with invalid email' do 
    #can't use log_in_as here
  end

  it 'Prevents login with incorrect password' do 
    log_in_as(CC_HARVARD, WRONG_PASSWORD)
    # expect error message 
  end

  it 'Prevents login as unlicensed user' do 
    log_in_as(NOLICENSE_MARTIN)
  end

end
