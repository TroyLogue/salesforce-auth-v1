# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Exports < BasePage
  NEW_EXPORT_BUTTON = { css: '#create-new-export-btn' }.freeze
  EXPORTS_TABLE = { css: '.exports-table' }.freeze
  EXPORT_DIALOG_CONTENT = { css: '.dialog.open.large .exports-create-form' }.freeze
  EXPORT_FIELD = { xpath: '//label[text()="%s"]/parent::div' }.freeze
  EXPORT_SOURCE_SELECT_LIST_OPEN = { css: '.choices.is-open.is-focused' }.freeze
  EXPORT_SOURCE_CHOICE_NETWORK = { css: '#choices-export-create-input__type-item-choice-1' }.freeze
  EXPORT_SOURCE_CHOICE_ORG = { css: '#choices-export-create-input__type-item-choice-2' }.freeze
  EXPORT_SOURCE_CHOICE_SELECTED = { css: '#export-create-input__type + .choices__list > div[aria-selected="true"]' }.freeze
  REMOVE_DEFAULT_CHOICE_SELECTED = { css: '#export-create-input__type + .choices__list > div[aria-selected="true"] > button' }.freeze
  EXPORT_SOURCE_CLOSE = { css: '.multiple-selector.open' }.freeze
  EXPORT_TYPE_CHOICE = { css: '.is-open div[id^="choices-export-create-input__type-item-choice-"]' }.freeze
  EXPORT_COMPARISON_FIELD_CHOICE = { css: 'div[id^="choices-export-create-input__filter-item-choice-"]' }.freeze
  EXPORT_DATE_RANGE_CHOICE = { css: 'div[id^="choices-export-create-input__period-item-choice-"]:not([data-value="custom"])' }.freeze
  SUBMIT_BUTTON = { css: '#form-footer-submit-btn' }.freeze

  # Export Source Options
  NETWORK = 'Networks'
  ORGANIZATION = 'Organizations'

  # Date Range Options
  DAYS_7 = 'Last 7 Days'

  INDEX_PATH = '/exports'

  def page_displayed?
    is_displayed?(NEW_EXPORT_BUTTON) &&
      is_displayed?(EXPORTS_TABLE)
  end

  def click_new_export
    click(NEW_EXPORT_BUTTON)
    is_displayed?(EXPORT_DIALOG_CONTENT)
  end

  def select_export_source_cc(source:)
    click(EXPORT_FIELD.transform_values { |v| v % 'Export Source(s)' })
    is_displayed?(EXPORT_SOURCE_SELECT_LIST_OPEN)

    #TODO CPR-89 made the change to have the default set to the cc. Waiting to hear from product to determine whether the default is needed or not
    click(REMOVE_DEFAULT_CHOICE_SELECTED)
    if source == NETWORK
      click(EXPORT_SOURCE_CHOICE_NETWORK)
    elsif source == ORGANIZATION
      click(EXPORT_SOURCE_CHOICE_ORG)
    end

    is_displayed?(EXPORT_SOURCE_CHOICE_SELECTED)

    click(EXPORT_SOURCE_CLOSE)
    is_not_displayed?(EXPORT_SOURCE_CLOSE, 0.5)
  end

  def select_random_export_type
    click(EXPORT_FIELD.transform_values { |v| v % 'Export Type' })
    click_random(EXPORT_TYPE_CHOICE)
  end

  def select_random_comparison_field
    click(EXPORT_FIELD.transform_values { |v| v % 'Comparison Field' })
    click_random(EXPORT_COMPARISON_FIELD_CHOICE)
  end

  def select_smallest_date_range
    # To not overwhelm the queue, we wanto pick the smallest date range
    click(EXPORT_FIELD.transform_values { |v| v % 'Date Range' })
    click_element_from_list_by_text(EXPORT_DATE_RANGE_CHOICE, DAYS_7)
  end

  def fill_export_form_CC_01_USER(source:)
    select_export_source_cc(source: source)
    select_random_export_type
    select_random_comparison_field
    select_smallest_date_range
  end

  def fill_export_form_org_user
    select_random_export_type
    select_random_comparison_field
    select_smallest_date_range
  end

  def submit_export_form
    click(SUBMIT_BUTTON)
  end

  def has_pending?
    wait_for_spinner
    wait_for_notification_to_disappear
    text_include?('Pending', EXPORTS_TABLE)
  end
end
