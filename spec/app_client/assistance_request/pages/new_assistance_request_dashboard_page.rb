require_relative '../../../shared_components/base_page'

class NewAssistanceRequestDashboardPage < BasePage
  NEW_AR_DASHBOARD_TABLE = { css: '#new-assistance-requests-table' }.freeze
  
  def go_to_new_ar_dashboard_page
    get("/dashboard/new/assistance-requests")
    wait_for_spinner
  end

  def new_ar_dashboard_page_displayed?
    is_displayed?(NEW_AR_DASHBOARD_TABLE)
  end

  def clients_new_ar_created?(client_name)
    find_elements(NEW_AR_DASHBOARD_TABLE).any? { |name| name.text.include?(client_name) }
  end
end
