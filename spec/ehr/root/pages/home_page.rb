require_relative '../../../shared_components/base_page'

class HomePage < BasePage
  MY_NETWORK_EHR = { css: '#nav-network' }

  def go_to_my_network
    click(MY_NETWORK_EHR)
  end

  def page_displayed?
    is_displayed?(MY_NETWORK_EHR)
  end
end
