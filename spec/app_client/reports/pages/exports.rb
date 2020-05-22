require_relative '../../../shared_components/base_page'

class Exports < BasePage
  NEW_EXPORT_BUTTON = { css: '#create-new-export-btn' }
  EXPORTS_TABLE = { css: '.exports-table' }
  EXPORT_DIALOG_CONTENT = { css: '.dialog.open.large .dialog-content' }
  EXPORT_FIELD = { xpath: '//label[text()="%s"]/parent::div' }
  EXPORT_SOURCE_SELECT_LIST_OPEN = { css: '.choices.is-open.is-focused' }
  EXPORT_SOURCE_CHOICE = { css: '#choices-export-create-input__type-item-choice-1' }
  EXPORT_SOURCE_CHOICE_SELECTED = { css: '#export-create-input__type + .choices__list > div[aria-selected="true"]' }
  EXPORT_SOURCE_CLOSE = { css: '.multiple-selector.open' }
  EXPORT_TYPE_CHOICE = { css: 'div[id^="choices-export-create-input__type-item-choice-"]' }
  EXPORT_COMPARISON_FIELD_CHOICE = { css: 'div[id^="choices-export-create-input__filter-item-choice-"]' }
  EXPORT_DATE_RANGE_CHOICE = { css: 'div[id^="choices-export-create-input__period-item-choice-"]' }
  SUBMIT_BUTTON = { css: '#form-footer-submit-btn' }

  #Export Type Options
  ASSESSMENT = 'Assessments'
  CASES = 'Cases'
  CLIENTS = 'Clients'
  NOTES = 'Notes'
  REFERALS = 'Referals'
  EPISODE_RAW = 'Service Episodes (Raw)'
  EPISODE_SNAPSHOT = 'Service Episodes (Snapshot)'
  USERS = 'Users'

  #Comparison Field Options
  CREATED = 'Created'
  CREATE_UPDATED = 'Created or Updated'
  UPDATED = 'Updated'

  #Date Range Options
  DAYS_7 = 'Last 7 Days'
  DAYS_30 = 'Last 30 Days'
  DAYS_60 = 'Last 60 Days'
  DAYS_90 = 'Last 90 Days'

  def page_displayed?
    is_displayed?(NEW_EXPORT_BUTTON) &&
    is_displayed?(EXPORTS_TABLE)
  end

  def click_new_export
    click(NEW_EXPORT_BUTTON)
    sleep_for(1) #Waiting for animation
    is_displayed?(EXPORT_DIALOG_CONTENT)
  end

  def select_export_source
    click(EXPORT_FIELD.transform_values { |v| v % 'Export Source(s)' })
    is_displayed?(EXPORT_SOURCE_SELECT_LIST_OPEN)

    click(EXPORT_SOURCE_CHOICE)
    is_displayed?(EXPORT_SOURCE_CHOICE_SELECTED)

    click(EXPORT_SOURCE_CLOSE)
    is_not_displayed?(EXPORT_SOURCE_CLOSE, 0.5)
  end

  def select_export_type(type = ASSESSMENT)
    click(EXPORT_FIELD.transform_values { |v| v % 'Export Type' })
    click_element_from_list_by_text(EXPORT_TYPE_CHOICE, type)
  end

  def select_comparison_field(type = CREATED)
    click(EXPORT_FIELD.transform_values { |v| v % 'Comparison Field' })
    click_element_from_list_by_text(EXPORT_COMPARISON_FIELD_CHOICE, type)
  end

  def select_date_range(type = DAYS_30)
    click(EXPORT_FIELD.transform_values { |v| v % 'Date Range' })
    click_element_from_list_by_text(EXPORT_DATE_RANGE_CHOICE, type)
  end

  def fill_export_form_user
    select_export_source
    select_export_type(ASSESSMENT)
    select_comparison_field(CREATED)
    select_date_range(DAYS_30)
  end

  def fill_export_form_org
    select_export_type(ASSESSMENT)
    select_comparison_field(CREATED)
    select_date_range(DAYS_30)
  end

  def submit_export_form
    click(SUBMIT_BUTTON)
  end

  def has_pending?
    wait_for_spinner
    text_include?('Pending', EXPORTS_TABLE)
  end
end
