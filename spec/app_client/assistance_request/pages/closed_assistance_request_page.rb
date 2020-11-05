require_relative '../../../shared_components/base_page'

class ClosedAssistanceRequestPage < BasePage
  STATUS_DETAIL = { css: '.detail-status-text' }.freeze
  OUTCOME_NOTES = { css: '.expandable-container__content-children' }.freeze
  DATE_CLOSED_LABEL = { css: '#outcome-column-two-table-date-closed-value' }.freeze

  def go_to_closed_ar_with_id(ar_id:)
    get("/dashboard/assistance-requests/closed/#{ar_id}")
    wait_for_spinner
  end
  
  def status_detail_text
    text(STATUS_DETAIL)
  end

  def outcome_note_text
    text(OUTCOME_NOTES)
  end

  def get_date_closed_text
    text(DATE_CLOSED_LABEL)
  end
end
