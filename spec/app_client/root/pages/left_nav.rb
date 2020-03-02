require_relative '../../../shared_components/base_page'

class LeftNav < BasePage

  MY_NETWORK_LINK = { css: '#nav-network' }
  REPORTS_LINK = { css: '#nav-report' }
  EXPORTS_LINK = { css: '.network-menu-exports-btn' }

  def go_to_my_network
    click(MY_NETWORK_LINK)
  end 

  def go_to_reports
    click(REPORTS_LINK)
  end

  def go_to_exports
    go_to_reports
    click(EXPORTS_LINK)
  end
end
