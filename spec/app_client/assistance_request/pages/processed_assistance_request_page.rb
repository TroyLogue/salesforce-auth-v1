require_relative '../../../shared_components/base_page'

class ProcessedAssistanceRequestPage < BasePage
  STATUS_DETAIL = { css: '.detail-status-text' }.freeze
  OUTCOME_NOTES = { css: '.expandable-container__content-children' }.freeze
  DATE_CLOSED_LABEL = { css: '#basic-table-date-submitted-value' }.freeze
  PROCESSED_STATUS_TEXT = 'PROCESSED'

  def go_to_processed_ar_with_id(ar_id:)
    get("/dashboard/assistance-requests/processed/#{ar_id}")
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