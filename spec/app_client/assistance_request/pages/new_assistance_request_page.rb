require_relative '../../../shared_components/base_page'

class NewAssistanceRequestPage < BasePage
  DASHBOARD_TABLE = { css: '#new-assistance-requests-table-header-row' }
  
  def new_ar_dashboard_displayed?
    is_displayed?(DASHBOARD_TABLE)
  end
end
