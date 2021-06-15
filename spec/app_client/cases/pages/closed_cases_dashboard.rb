require_relative '../../../shared_components/base_page'

class ClosedCasesDashboard < BasePage
  CLOSED_CASES_TABLE = { css: '#closed-cases-table' }.freeze

  def page_displayed?
    is_displayed?(CLOSED_CASES_TABLE)
  end
end

