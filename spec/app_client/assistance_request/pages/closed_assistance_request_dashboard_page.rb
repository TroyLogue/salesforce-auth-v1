require_relative '../../../shared_components/base_page'

class ClosedAssistanceRequestDashboardPage < BasePage
  CLOSED_AR_DASHBOARD_TABLE = { css: '#closed-assistance-requests-table-header-row' }.freeze
  
  def go_to_closed_ar_dashboard_page
    get("/dashboard/assistance-requests/closed")
    wait_for_spinner
  end

  def closed_ar_dashboard_page_displayed?
    is_displayed?(CLOSED_AR_DASHBOARD_TABLE)
  end

  # In the app, all AR closed in the day of has a HH:MM time and everything else has MM/DD date.
  # So this method returns the time from date closed column in the closed AR dashboard page.
  def date_closed_column_text(client_name)
    text({ xpath: "//*[contains(text(), '#{client_name}')]/following::td[3]"} )
  end
end