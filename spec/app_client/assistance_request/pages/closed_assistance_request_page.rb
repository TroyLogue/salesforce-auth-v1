require_relative '../../../shared_components/base_page'

class ClosedAssistanceRequestPage < BasePage
  STATUS_DETAIL = { css: '.detail-status-text' }
  OUTCOME_NOTES = { css: '.expandable-container__content-children' }

  def status_detail_text
    text(STATUS_DETAIL)
  end

  def outcome_note_text
    text(OUTCOME_NOTES)
  end
end
