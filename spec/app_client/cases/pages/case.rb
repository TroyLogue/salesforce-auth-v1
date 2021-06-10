# frozen_string_literal: true

class Case < BasePage
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }.freeze
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }.freeze
  CASE_VIEW = { css: '.dashboard-content .case-detail-view' }.freeze
  CASE_STATUS = { css: '.detail-status-text' }.freeze
  CLOSE_CASE_SUBMIT_BTN = { css: '#close-case-submit-btn' }.freeze
  DOCUMENT_LIST = { css: '.list-view-document__title' }.freeze
  EXIT_DATE_INPUT = { css: '#exitDateInput' }.freeze
  MILITARY_ASSESSMENT = { css: '#military-information-link' }.freeze
  NOTE_INPUT = { css: '#noteInput' }.freeze
  NOTES = { css: '.detail-info__summary p > span' }.freeze
  OPEN_STATUS = 'OPEN'
  OUTCOME_DROPDOWN = { xpath: '//label[text()="Outcome"]/parent::div' }.freeze
  OUTCOME_DROPDOWN_CHOICES = { css: 'div[id^="choices-outcomeInput-item-choice-"]' }.freeze
  PRIMARY_WORKER = { css: '#basic-table-primary-worker-value' }.freeze
  REFERRED_TO = { css: '#basic-table-referred-to-value' }.freeze
  RESOLUTION_DROPDOWN = { xpath: '//label[text()="Is Resolved?"]/parent::div' }.freeze
  RESOLUTION_DROPDOWN_CHOICES = { css: 'div[id^="choices-resolvedInput-item-choice-"]' }.freeze
  SERVICE_TYPE = { css: '#basic-table-service-type-value' }.freeze

  REOPEN_BTN = { css: '#reopen-case' }.freeze
  CLOSE_BTN = { css: '#close-case-btn' }.freeze

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def close_case_with_random_values
    is_displayed?(CLOSE_BTN) && click(CLOSE_BTN)
    # in modal
    resolution = select_random_resolution
    outcome = select_random_outcome
    note = enter_random_note
    exit_date = enter_random_exit_date

    click(CLOSE_CASE_SUBMIT_BTN)
    { resolution: resolution, outcome: outcome, note: note, exit_date: exit_date }
  end

  def enter_random_note
    note = Faker::Lorem.sentence(word_count: 5)
    enter(note, NOTE_INPUT)
    note
  end

  def enter_random_exit_date
    # date must be today's date or earlier:
    # use a random date within the past year
    date = Faker::Date.backward(days: 365).strftime("%m%d%Y")
    clear_then_enter(date, EXIT_DATE_INPUT)
    date
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

  def select_random_resolution
    click(RESOLUTION_DROPDOWN)
    random_resolution_element = find_elements(RESOLUTION_DROPDOWN_CHOICES).sample
    resolution = random_resolution_element.text
    random_resolution_element.click
    resolution
  end

  def select_random_outcome
    click(OUTCOME_DROPDOWN)
    random_outcome_element = find_elements(OUTCOME_DROPDOWN_CHOICES).sample
    outcome = random_outcome_element.text
    random_outcome_element.click
    outcome
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
