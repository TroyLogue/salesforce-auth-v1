require_relative '../../../shared_components/base_page'

class NewAssistanceRequestPage < BasePage
  #Close AR page
  TAKE_ACTION = { css: '.choices__item' }.freeze
  START_INTAKE_CHOICE = { css: '#choices-assistance-request-action-select-item-choice-2' }.freeze
  REQUEST_CLOSE = { css: '#choices-assistance-request-action-select-item-choice-5' }.freeze
  IS_RESOLVED = { css: '#resolved-input' }.freeze
  STATUS_DETAIL = { css: '.detail-status-text' }.freeze
  
  #Close AR Modal
  RESOLUTION_INPUT = { css: '.choices__input--cloned' }.freeze
  OUTCOME = { css: '#outcome-input' }.freeze
  OUTCOME_CHOICE = { css: '#choices-outcome-input-item-choice-1' }.freeze
  CLOSING_NOTE = { css: '#note-input' }.freeze
  CLOSE_BUTTON = { css: '#close-ar-close-btn' }.freeze
  AR_CLOSE_MODAL = { css: '.close-ar__inputs' }.freeze

  #AR Statuses
  NEED_ACTION_STATUS_TEXT = 'NEEDS ACTION'
  
  def go_to_new_ar_with_id(ar_id:)
    get("/dashboard/new/assistance-requests/#{ar_id}")
    wait_for_spinner
  end
  
  def select_start_intake_action
    click(TAKE_ACTION)
    click(START_INTAKE_CHOICE)
  end

  def select_close_assistance_request
    is_displayed?(STATUS_DETAIL)
    click(TAKE_ACTION)
    is_displayed?(REQUEST_CLOSE)
    click(REQUEST_CLOSE)
  end

  def close_ar_modal_displayed?
    is_displayed?(AR_CLOSE_MODAL)
  end

  def enter_close_ar_resolution(resolution_type)
    click_via_js(IS_RESOLVED)
    enter(resolution_type, RESOLUTION_INPUT)
    find(RESOLUTION_INPUT).send_keys :enter
  end

  def select_close_ar_outcome
    click_via_js(OUTCOME)
    click(OUTCOME_CHOICE)
  end

  def enter_close_ar_note(note)
    enter(note, CLOSING_NOTE)
  end

  def submit_close_ar
    click(CLOSE_BUTTON)
  end

  def status_detail_text
    text(STATUS_DETAIL)
  end

  def close_assistance_request(note, resolution_type)
    select_close_assistance_request
    close_ar_modal_displayed?
    enter_close_ar_resolution(resolution_type)
    select_close_ar_outcome
    enter_close_ar_note(note)
    submit_close_ar
  end
end