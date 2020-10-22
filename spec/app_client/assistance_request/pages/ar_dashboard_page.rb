require_relative '../../../shared_components/base_page'

class AssistanceRequest < BasePage
  TAKE_ACTION = { css: '.choices__item' }.freeze
  START_INTAKE_CHOICE = { css: '#choices-assistance-request-action-select-item-choice-2' }.freeze
  REQUEST_CLOSE = { css: '#choices-assistance-request-action-select-item-choice-5' }
  IS_RESOLVED = { css: '#resolved-input' }
  RESOLVED = { css: '#choices-resolved-input-item-choice-1' }
  OUTCOME = { css: '#outcome-input' }
  OUTCOME_CHOICE = { css: '#choices-outcome-input-item-choice-1' }
  CLOSING_NOTE = { css: '#note-input' }
  CLOSE_BUTTON = { css: '#close-ar-close-btn' }
  STATUS_DETAIL = { css: '.detail-status-text' }
  AR_CLOSE_MODAL = { css: '.close-ar__inputs' }
  DASHBOARD_TABLE = { css: '#new-assistance-requests-table-header-row' }
  
  def go_to_new_ar_with_id(ar_id:)
    get("/dashboard/new/assistance-requests/#{ar_id}")
    wait_for_spinner
  end

  def go_to_closed_ar_with_id(ar_id:)
    get("/dashboard/assistance-requests/closed/#{ar_id}")
    wait_for_spinner
  end
  
  def select_start_intake_action
    click(TAKE_ACTION)
    click(START_INTAKE_CHOICE)
  end

  def select_close_assistance_request
    find(STATUS_DETAIL)
    click(TAKE_ACTION)
    is_displayed?(REQUEST_CLOSE)
    click(REQUEST_CLOSE)
  end

  def close_ar_modal_displayed?
    is_displayed?(AR_CLOSE_MODAL)
  end

  def close_ar_resolution_field
    click_via_js(IS_RESOLVED)
    click(RESOLVED)
  end

  def close_ar_outcome_field
    click_via_js(OUTCOME)
    click(OUTCOME_CHOICE)
  end

  def close_ar_note_field(note)
    enter(note, CLOSING_NOTE)
  end

  def close_ar_modal
    click(CLOSE_BUTTON)
  end

  def new_ar_dashboard_displayed?
    is_displayed?(DASHBOARD_TABLE)
  end

  def status_detail_text
    text(STATUS_DETAIL)
  end

  def close_assistance_request(note)
    select_close_assistance_request
    close_ar_modal_displayed?
    close_ar_resolution_field
    close_ar_outcome_field
    close_ar_note_field(note)
    close_ar_modal
    new_ar_dashboard_displayed?
  end
end