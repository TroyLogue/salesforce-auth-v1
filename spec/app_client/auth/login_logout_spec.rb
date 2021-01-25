require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'

describe '[Auth - Login - Logout]', :app_client, :auth, :login do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }

  it 'Logs in with a valid email, then logs out', :uuqa_5, :uuqa_1608 do
    log_in_as(Login::CC_HARVARD)
    expect(home_page.page_displayed?).to be_truthy
    user_menu.log_out
    expect(login_email.page_displayed?).to be_truthy
  end

  it 'Prevents login with incorrect password', :uuqa_9 do
    log_in_as(Login::CC_HARVARD, Login::WRONG_PASSWORD)
    expect(login_password.page_displayed?).to be_truthy
    expect(login_password.invalid_alert_displayed?).to be_truthy
  end

  it 'Prevents login as unlicensed user', :uuqa_778 do
    log_in_as(Login::NOLICENSE_MARTIN)
    expect(login_password.page_displayed?).to be_truthy
    expect(login_password.invalid_alert_displayed?).to be_truthy
  end
end
