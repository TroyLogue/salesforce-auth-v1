require_relative '../../../shared_components/base_page'

class LeftNav < BasePage
  DASHBOARD_LINK = { css: '#nav-workflow-dashboard' }
  MY_NETWORK_LINK = { css: '#nav-network' }
  REPORTS_LINK = { css: '#nav-report' }
  EXPORTS_LINK = { css: '.network-menu-exports-btn' }
  CLIENTS_LINK = { css: '#nav-clients' }

  def clients_path
    "/dashboard/clients/all"
  end

  def go_to_dashboard
    click(DASHBOARD_LINK)
  end

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

  def go_to_clients
    click(CLIENTS_LINK)
    wait_for_spinner
  end
end
