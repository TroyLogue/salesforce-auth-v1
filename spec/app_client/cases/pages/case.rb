# frozen_string_literal: true

class Case < BasePage
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }.freeze
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }.freeze
  CASE_VIEW = { css: '.dashboard-content .case-detail-view' }.freeze
  CASE_STATUS = { css: '.detail-status-text' }.freeze
  DOCUMENT_LIST = { css: '.list-view-document__title' }.freeze
  MILITARY_ASSESSMENT = { css: '#military-information-link' }.freeze
  NOTES = { css: '.detail-info__summary p > span' }.freeze
  OPEN_STATUS = 'OPEN'
  PRIMARY_WORKER = { css: '#basic-table-primary-worker-value' }.freeze
  REFERRED_TO = { css: '#basic-table-referred-to-value' }.freeze
  SERVICE_TYPE = { css: '#basic-table-service-type-value' }.freeze

  # Contracted Service
  ADD_CONTRACTED_SERVICES_BUTTON = {
    css: '.add-fee-schedule-program-information__section .add-circle-plus__text'
  }.freeze
  CONTRACTED_SERVICES_FORM = { css: '.payments-track-service' }.freeze
  SUBMIT_CONTRACTED_SERVICES = { css: '#fee-schedule-provided-service-post-note-btn' }.freeze
  UNIT_AMOUNT = { css: '#provided-service-unit-amount' }.freeze
  STARTS_AT = { css: '#provided-service-date' }.freeze
  ORIGIN_INPUT_ADDRESS_LINE1 = { css: 'input[name$="[0].address.line_1"]' }.freeze
  ORIGIN_INPUT_ADDRESS_LINE2 = { css: 'input[name$="[0].address.line_2"]' }.freeze
  ORIGIN_INPUT_ADDRESS_CITY = { css: 'input[name$="[0].address.city"]' }.freeze
  ADDRESS_STATE_INPUT = { css: 'select[name$="[0].address.state"]' }.freeze
  EXPAND_ORIGIN_STATE_LIST = { css: 'select[name$="[0].address.state"] + div' }.freeze
  LIST_ORIGIN_STATE_CHOICES = {
    css: '.payments-track-service__metafields div:first-child div[id^="choices-undefined-state-item-choice"]'
  }.freeze
  ORIGIN_INPUT_ADDRESS_ZIP = { css: 'input[name$="[0].address.postal_code"]' }.freeze
  DESTINATION_INPUT_ADDRESS_LINE1 = { css: 'input[name$="[1].address.line_1"]' }.freeze
  DESTINATION_INPUT_ADDRESS_LINE2 = { css: 'input[name$="[1].address.line_2"]' }.freeze
  DESTINATION_INPUT_ADDRESS_CITY = { css: 'input[name$="[1].address.city"]' }.freeze
  EXPAND_DESTINATION_STATE_LIST = { css: 'select[name$="[1].address.state"] + div' }.freeze
  LIST_DESTINATION_STATE_CHOICES = {
    css: '.payments-track-service__metafields div:nth-child(2) div[id^="choices-undefined-state-item-choice"]'
  }.freeze
  DESTINATION_INPUT_ADDRESS_ZIP = { css: 'input[name$="[1].address.postal_code"]' }.freeze
  TOLL_COST = { css: 'input[name$="value"]' }.freeze
  CONTRACTED_SERVICE_DETAIL_CARD = { css: '.fee-schedule-provided-service-card' }.freeze

  REOPEN_BTN = { css: '#reopen-case' }.freeze
  CLOSE_BTN = { css: '#close-case-btn' }.freeze

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def click_contracted_service_button
    is_displayed?(ADD_CONTRACTED_SERVICES_BUTTON) && click(ADD_CONTRACTED_SERVICES_BUTTON)
  end

  def contracted_service_form_displayed?
    is_displayed?(CONTRACTED_SERVICES_FORM)
  end

  def submit_contracted_services_form(values)
    enter(values[:unit_amount], UNIT_AMOUNT) if UNIT_AMOUNT
    enter(values[:starts_at], STARTS_AT) if STARTS_AT

    # Fills out origin address
    if ORIGIN_INPUT_ADDRESS_LINE1
      enter(values[:origin_address][:origin_address_line1],
            ORIGIN_INPUT_ADDRESS_LINE1)
    end
    if ORIGIN_INPUT_ADDRESS_LINE2
      enter(values[:origin_address][:origin_address_line2],
            ORIGIN_INPUT_ADDRESS_LINE2)
    end
    if ORIGIN_INPUT_ADDRESS_CITY
      enter(values[:origin_address][:origin_city],
            ORIGIN_INPUT_ADDRESS_CITY)
    end
    click(EXPAND_ORIGIN_STATE_LIST)
    click_element_from_list_by_text(LIST_ORIGIN_STATE_CHOICES,
                                    values[:origin_address][:origin_state])
    if ORIGIN_INPUT_ADDRESS_ZIP
      enter(values[:origin_address][:origin_zip],
            ORIGIN_INPUT_ADDRESS_ZIP)
    end

    # Fills out destination address
    if DESTINATION_INPUT_ADDRESS_LINE1
      enter(values[:destination_address][:destination_address_line1],
            DESTINATION_INPUT_ADDRESS_LINE1)
    end
    if DESTINATION_INPUT_ADDRESS_LINE2
      enter(values[:destination_address][:destination_address_line2],
            DESTINATION_INPUT_ADDRESS_LINE2)
    end
    if DESTINATION_INPUT_ADDRESS_CITY
      enter(values[:destination_address][:destination_city],
            DESTINATION_INPUT_ADDRESS_CITY)
    end
    click(EXPAND_DESTINATION_STATE_LIST)
    click_element_from_list_by_text(LIST_DESTINATION_STATE_CHOICES,
                                    values[:destination_address][:destination_state])
    if DESTINATION_INPUT_ADDRESS_ZIP
      enter(values[:destination_address][:destination_zip],
            DESTINATION_INPUT_ADDRESS_ZIP)
    end

    enter(values[:toll_cost], TOLL_COST) if TOLL_COST

    # Submits contracted services form and closes form
    click_submit_contracted_services_button
    is_not_displayed?(CONTRACTED_SERVICES_FORM)
    create_detail_card_displayed?
  end

  def create_detail_card_displayed?
    is_displayed?(CONTRACTED_SERVICE_DETAIL_CARD)
  end

  def click_submit_contracted_services_button
    click SUBMIT_CONTRACTED_SERVICES
  end

  def go_to_open_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/open/#{case_id}/contact/#{contact_id}")
  end

  def go_to_closed_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/closed/#{case_id}/contact/#{contact_id}")
  end

  def status
    text(CASE_STATUS)
  end

  def service_type
    text(SERVICE_TYPE)
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
