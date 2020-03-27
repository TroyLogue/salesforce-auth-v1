require_relative '../../../shared_components/base_page'

class Exports < BasePage
  NEW_EXPORT_BUTTON = { css: '#create-new-export-btn' }
  EXPORTS_TABLE = { css: '.exports-table' }
  EXPORT_DIALOG_CONTENT = { css: '.dialog.open.large .dialog-content' }
  EXPORT_FIELD = { xpath: "//label[text()='%s']/parent::div" }
  EXPORT_SOURCE_SELECT_LIST_OPEN = { css: '.choices.is-open.is-focused' }
  EXPORT_SOURCE_CHOICE = { css: '#choices-export-create-input__type-item-choice-1' }
  EXPORT_SOURCE_CHOICE_SELECTED = { css: '#export-create-input__type + .choices__list > div[aria-selected="true"]' }
  EXPORT_SOURCE_CLOSE = { css: '.multiple-selector.open' }
  EXPORT_TYPE_CHOICE = { css: "div[id^='choices-export-create-input__type-item-choice-']"}
  EXPORT_COMPARISON_FIELD_CHOICE = { css: "div[id^='choices-export-create-input__filter-item-choice-']" }
  EXPORT_DATE_RANGE_CHOICE = { css: "div[id^='choices-export-create-input__period-item-choice-']" }
  SUBMIT_BUTTON = { css: '#form-footer-submit-btn' }

  def page_displayed?
    is_displayed?(NEW_EXPORT_BUTTON)
    is_displayed?(EXPORTS_TABLE)
  end

  def click_new_export
    click(NEW_EXPORT_BUTTON)
    sleep_for(1) #Waiting for animation
    is_displayed?(EXPORT_DIALOG_CONTENT)
  end

  def select_export_source
    click(EXPORT_FIELD.transform_values{|v| v % 'Export Source(s)'})
    is_displayed?(EXPORT_SOURCE_SELECT_LIST_OPEN)
    
    click(EXPORT_SOURCE_CHOICE)
    is_displayed?(EXPORT_SOURCE_CHOICE_SELECTED)
    
    click(EXPORT_SOURCE_CLOSE)
    is_not_displayed?(EXPORT_SOURCE_CLOSE, 0.5)
  end

  def select_export_type(type)
    # Accepted Types:
    # Assessment # Cases # Clients # Notes # Referals # Service Episodes (Raw) # Service Episodes (Snapshot) # Users
    click(EXPORT_FIELD.transform_values{|v| v % 'Export Type'})
    click_element_from_list_by_text(EXPORT_TYPE_CHOICE, type)
  end

  def select_comparison_field(type)
    # Accepted Types:
    # Created # Created or Updated # Updated 
    click(EXPORT_FIELD.transform_values{|v| v % 'Comparison Field'})
    click_element_from_list_by_text(EXPORT_COMPARISON_FIELD_CHOICE, type)
  end

  def select_date_range(type)
    # Accepted Types:
    # Last 30 Days # Last 60 Days # Last 7 Days # Last 90 Days
    click(EXPORT_FIELD.transform_values{|v| v % 'Date Range'})
    click_element_from_list_by_text(EXPORT_DATE_RANGE_CHOICE, type)
  end

  def fill_export_form_user
    select_export_source
    select_export_type('Assessments')
    select_comparison_field('Created')
    select_date_range('Last 30 Days')
  end

  def fill_export_form_org
    select_export_type('Assessments')
    select_comparison_field('Created')
    select_date_range('Last 30 Days')
  end 

  def submit_export_form
    click(SUBMIT_BUTTON)
  end

  def has_pending?
    wait_for_spinner_to_disappear()
    text_include?('Pending', EXPORTS_TABLE)
  end
end
