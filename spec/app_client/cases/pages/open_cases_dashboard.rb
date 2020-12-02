require_relative '../../../shared_components/base_page'

class OpenCasesDashboard < BasePage
  OPEN_CASES_TABLE = { css: '.dashboard-content #open-cases-table' }
  CLIENT_NAME_COLUMN = { css: '.ui-table-row-column.dynamic-table__row-column span' }
  
  def open_cases_table_displayed?
    is_displayed?(OPEN_CASES_TABLE)
  end

  def open_case_client_name
    text(CLIENT_NAME_COLUMN)
  end
end