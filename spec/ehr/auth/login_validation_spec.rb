require_relative '../auth/helpers/login_ehr'

describe '[Login –– ]', :ehr, :auth, :login do
  include LoginEhr

  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }

  it 'with incorrect password', :uuqa_392 do
    log_in_default_as(LoginEhr::CC_HARVARD, LoginEhr::WRONG_PASSWORD)
    expect(login_password_ehr.page_displayed?).to be_truthy
    expect(login_password_ehr.invalid_alert_displayed?).to be_truthy
  end

  it 'with inactive user', :uuqa_1531 do
    log_in_dashboard_as(LoginEhr::INACTIVE_BOB)
    expect(login_email_ehr.signed_out_message_displayed?).to be_truthy
  end
end
