# frozen_string_literal: true

class Case < BasePage
  ADD_ANOTHER_OON_RECIPIENT = { css: '#add-another-oon-group-btn' }.freeze
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }.freeze
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }.freeze
  CASE_VIEW = { css: '.dashboard-content .case-detail-view' }.freeze
  CASE_STATUS = { css: '.detail-status-text' }.freeze
  CUSTOM_OON_INPUT = { css: '.case-oon-group-select .is-open input[type="text"]' }.freeze
  DOCUMENT_LIST = { css: '.list-view-document__title' }.freeze
  EDIT_REFERRED_TO = { css: '.service-case-details__edit-section #service-case-details__edit-button' }.freeze
  MILITARY_ASSESSMENT = { css: '#military-information-link' }.freeze
  NOTES = { css: '.detail-info__summary p > span' }.freeze
  # second oon org input; first oon provider - HARDCODED
  OON_ORG_FIRST_OPTION = { id: 'choices-select-field-oon-group-1-item-choice-3' }.freeze
  OPEN_STATUS = 'OPEN'
  PRIMARY_WORKER = { css: '#basic-table-primary-worker-value' }.freeze
  REFERRED_TO = { css: '#basic-table-referred-to-value .service-case-referred-to__text' }.freeze
  REFERRED_TO_DROPDOWN = { css: '.case-oon-group-select .choices' }.freeze
  SAVE_REFERRED_TO = { css: '#form-footer-submit-btn' }.freeze
  SERVICE_TYPE = { css: '#basic-table-service-type-value' }.freeze
  REOPEN_BTN = { css: '#reopen-case' }.freeze
  CLOSE_BTN = { css: '#close-case-btn' }.freeze

  def add_another_out_of_network_recipient
    click(ADD_ANOTHER_OON_RECIPIENT)
  end

  def add_custom_recipient(custom_recipient:)
    add_another_out_of_network_recipient
    click_last_referred_to_dropdown
    enter_and_return(custom_recipient, CUSTOM_OON_INPUT)
  end

  def add_first_oon_recipient
    add_another_out_of_network_recipient
    click_last_referred_to_dropdown
    recipient = strip_distance(text: text(OON_ORG_FIRST_OPTION))
    click(OON_ORG_FIRST_OPTION)
    recipient
  end

  def click_last_referred_to_dropdown
    referred_to_dropdowns = find_elements(REFERRED_TO_DROPDOWN)
    referred_to_dropdowns[-1].click
  end

  def open_edit_referred_to_modal
    click(EDIT_REFERRED_TO)
  end

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def go_to_open_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/open/#{case_id}/contact/#{contact_id}")
  end

  def go_to_closed_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/closed/#{case_id}/contact/#{contact_id}")
  end

  def save_referred_to
    click(SAVE_REFERRED_TO)
    wait_for_spinner
  end

  def status
    text(CASE_STATUS)
  end

  def service_type
    text(SERVICE_TYPE)
  end

  def strip_distance(text:)
    provider_distance_index = text.rindex(/\(/) # finds the last open paren in the string
    text[0..(provider_distance_index - 1)].strip
  end

  def referred_to
    text(REFERRED_TO)
  end

  # converts comma-separated list of orgs to array
  def referred_to_array
    text(REFERRED_TO).split(/\s*,\s*/)
  end

  def primary_worker
    text(PRIMARY_WORKER)
  end

  def notes
    text(NOTES)
  end

  def reopen_case
    is_displayed?(REOPEN_BTN) && click(REOPEN_BTN)
  end

  def close_case_button_displayed?
    is_displayed?(CLOSE_BTN)
  end

  # ASSSESMENTS
  def assessment_list
    text(ASSESSMENT_LIST)
  end

  def military_assessment_displayed?
    is_displayed?(MILITARY_ASSESSMENT)
  end

  def open_assessment(assessment_name:)
    click(ASSESSMENT_LINK.transform_values { |v| v % assessment_name })
  end

  def open_military_assessment
    click(MILITARY_ASSESSMENT)
  end

  # DOCUMENTS
  def document_list
    text(DOCUMENT_LIST)
  end
end
