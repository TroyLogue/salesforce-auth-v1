require_relative '../../../shared_components/base_page'

class LeftNav < BasePage

  MY_NETWORK_LINK = { css: '#nav-network' }

  def go_to_my_network
    click(MY_NETWORK_LINK)
  end 
end
