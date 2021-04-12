require_relative '../../../shared_components/base_page'

class ProcessedAssistanceRequestDashboardPage < BasePage
  PROCESSED_AR_DASHBOARD_TABLE = { css: '#processed-assistance-requests-table' }.freeze
  
  def go_to_processed_ar_dashboard_page
    get("/dashboard/assistance-requests/processed")
    wait_for_spinner
  end

  def processed_ar_dashboard_page_displayed?
    is_displayed?(PROCESSED_AR_DASHBOARD_TABLE)
  end

  def clients_ar_processed?(client_name)
    find_elements(PROCESSED_AR_DASHBOARD_TABLE).any? { |name| name.text.include?(client_name) }
  end
end
