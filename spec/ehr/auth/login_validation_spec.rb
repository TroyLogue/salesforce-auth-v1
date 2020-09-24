require_relative '../auth/helpers/login_ehr'
require_relative '../auth/pages/login_email_ehr'
require_relative '../auth/pages/login_password_ehr'

describe '[Login –– ]', :ehr, :auth, :login do
  include Login
  include LoginEhr

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }

  it 'with incorrect password' do
    log_in_default_as(Login::CC_HARVARD, Login::WRONG_PASSWORD)
    expect(login_password_ehr.page_displayed?).to be_truthy
    expect(login_password_ehr.invalid_alert_displayed?).to be_truthy
  end

  it 'with incorrect email address' do
    log_in_dashboard_as(Login::INVALID_USER)
    # verify incorrect error
    expect(login_email_ehr.incorrect_error_displayed?).to be_truthy
  end
end
