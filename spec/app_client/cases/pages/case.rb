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
  OUTCOME = { css: '#outcome-column-one-table-outcome-value' }.freeze
  OUTCOME_NOTES = { css: '#outcome-notes-expandable .expandable-container__content' }.freeze
  PRIMARY_WORKER = { css: '#basic-table-primary-worker-value' }.freeze
  PROGRAM_EXIT_DATE = { css: '.service-case-program-exit__text' }.freeze
  REFERRED_TO = { css: '#basic-table-referred-to-value' }.freeze
  RESOLUTION = { css: '#outcome-column-two-table-resolution-value' }.freeze
  SERVICE_TYPE = { css: '#basic-table-service-type-value' }.freeze

  #Closing Case modal
  CLOSE_CASE_SUBMIT_BTN = { css: '#close-case-submit-btn' }.freeze
  EXIT_DATE_INPUT = { css: '#exitDateInput' }.freeze
  NOTE_INPUT = { css: '#noteInput' }.freeze
  OUTCOME_DROPDOWN = { xpath: '//label[text()="Outcome"]/parent::div' }.freeze
  OUTCOME_DROPDOWN_CHOICES = { css: 'div[id^="choices-outcomeInput-item-choice-"]' }.freeze
  RESOLUTION_DROPDOWN = { xpath: '//label[text()="Is Resolved?"]/parent::div' }.freeze
  RESOLUTION_DROPDOWN_CHOICES = { css: 'div[id^="choices-resolvedInput-item-choice-"]' }.freeze

  REOPEN_BTN = { css: '#reopen-case' }.freeze
  CLOSE_BTN = { css: '#close-case-btn' }.freeze

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def closed_case_values
    {
      resolution: text(RESOLUTION),
      outcome: text(OUTCOME),
      note: text(OUTCOME_NOTES),
      exit_date: text(PROGRAM_EXIT_DATE)
    }
  end

  def close_case_with_random_values
    is_displayed?(CLOSE_BTN) && click(CLOSE_BTN)

    # within Close Case modal:
    resolution = select_random_resolution
    outcome = select_random_outcome
    note = enter_random_note
    exit_date = enter_random_exit_date

    click(CLOSE_CASE_SUBMIT_BTN)
    wait_for_spinner
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
    date = Faker::Date.backward(days: 365)
    formatted_date = date.strftime("%m%d%Y")
    clear_then_enter(formatted_date, EXIT_DATE_INPUT)
    # return the date in correct format for case detail view:
    date.strftime("%-m/%-d/%Y")
  end

  def go_to_open_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/open/#{case_id}/contact/#{contact_id}")
  end

  def go_to_closed_case_with_id(case_id:, contact_id:)
    get("/dashboard/cases/closed/#{case_id}/contact/#{contact_id}")
  end

  def closed_case_path(case_id:, contact_id:)
    "/dashboard/cases/closed/#{case_id}/contact/#{contact_id}"
  end

  def open_case_path(case_id:, contact_id:)
    "/dashboard/cases/open/#{case_id}/contact/#{contact_id}"
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
    is_displayed?(RESOLUTION_DROPDOWN) && click(RESOLUTION_DROPDOWN)
    random_resolution_element = find_elements(RESOLUTION_DROPDOWN_CHOICES).sample
    resolution = random_resolution_element.text
    random_resolution_element.click
    resolution
  end

  def select_random_outcome
    is_displayed?(OUTCOME_DROPDOWN) && click(OUTCOME_DROPDOWN)
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
