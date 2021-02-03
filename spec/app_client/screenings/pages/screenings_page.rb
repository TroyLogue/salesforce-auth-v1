require_relative '../../../shared_components/base_page'

class ScreeningsPage < BasePage
  SCREENINGS_TABLE = { id: 'all-screenings-table' }.freeze
  FIRST_CLIENT_ROW = { id: 'all-screenings-table-row-0' }.freeze
  AUTHORIZED_CLIENTS = { css: '.ui-table-body > tr:not(.unauthorized)' }
  CARE_COORDINATOR_FILTER = { id: 'care-coordinator-filter' }.freeze
  STATUS_FILTER = { id: 'status-filter' }.freeze
  GO_TO_FACESHEET_LINK = { class: 'client-name__link' }.freeze

  def page_displayed?
    is_displayed?(SCREENINGS_TABLE)
    wait_for_spinner
  end
end
