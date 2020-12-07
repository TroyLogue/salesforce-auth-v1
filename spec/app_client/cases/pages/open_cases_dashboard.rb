require_relative '../../../shared_components/base_page'

class OpenCasesDashboard < BasePage
  OPEN_CASES_TABLE = { css: '.dashboard-content #open-cases-table' }.freeze

  def open_cases_table_displayed?
    is_displayed?(OPEN_CASES_TABLE)
  end
end
