require_relative '../auth/helpers/login_ehr'

describe '[Login –– ]', :ehr, :auth, :login do
  include LoginEhr

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }

  it 'with incorrect password', :uuqa_392 do
    log_in_default_as(LoginEhr::CC_HARVARD, LoginEhr::WRONG_PASSWORD)
    expect(login_password_ehr.page_displayed?).to be_truthy
    expect(login_password_ehr.invalid_alert_displayed?).to be_truthy
  end

  it 'with unlicensed email address', :uuqa_1531 do
    log_in_dashboard_as(LoginEhr::NOLICENSE_MARTIN)
    expect(login_email_ehr.incorrect_error_displayed?).to be_truthy
  end
end
