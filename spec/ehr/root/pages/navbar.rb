require_relative '../../../shared_components/base_page'

class Navbar < BasePage
  MY_NETWORK_LINK_EHR = { css: '#nav-network' }
  CREATE_REFERRAL_LINK_EHR = { css: '#nav-referral' }
  USER_MENU = { css: '.right-nav__user-button' }
  LOG_OUT_BTN = { css: '.logout-btn' }

  def go_to_my_network
    click(MY_NETWORK_LINK_EHR)
  end

  def create_referral
    click(CREATE_REFERRAL_LINK)
  end

  def log_out
    click(USER_MENU)
    click(LOG_OUT_BTN)
  end

end
