require_relative '../../../shared_components/base_page'

class Exports < BasePage
  NEW_EXPORT_BUTTON = { css: '#create-new-export-btn' }
  EXPORT_SOURCE_SELECT_LIST = { css: '.export-create-fields__select:nth-of-type(1)' }
  EXPORT_SOURCE_CHOICE = { css: '#choices-export-create-input__type-item-choice-1' }
  EXPORT_TYPE_SELECT_LIST = { css: '.export-create-fields__select:nth-of-type(2)' }
  EXPORT_TYPE_CHOICE = EXPORT_SOURCE_CHOICE # to clarify: not the same element, but the same selector
  EXPORT_COMPARISON_FIELD_SELECT_LIST = { css: '.export-create-fields__select:nth-of-type(3)' }
  EXPORT_COMPARISON_FIELD_CHOICE = { css: '#choices-export-create-input__filter-item-choice-1' }
  EXPORT_DATE_RANGE_SELECT_LIST = { css: '.export-create-fields__select:nth-of-type(4)' }
  EXPORT_DATE_RANGE_CHOICE = { css: '#choices-export-create-input__period-item-choice-2' }
  SUBMIT_BUTTON = { css: '#form-footer-submit-btn' }

  def page_displayed?
    is_displayed?(NEW_EXPORT_BUTTON)
  end

  def click_new_export
    click(NEW_EXPORT_BUTTON)
  end

  def select_export_source
    click(EXPORT_SOURCE_SELECT_LIST)
    click(EXPORT_SOURCE_CHOICE)
    get_active_element().send_keys(:tab)    
  end

  def select_export_type
    click(EXPORT_TYPE_SELECT_LIST)
    click(EXPORT_TYPE_CHOICE)
  end

  def select_comparison_field
    click(EXPORT_COMPARISON_FIELD_SELECT_LIST)
    click(EXPORT_COMPARISON_FIELD_CHOICE)    
  end

  def select_date_range
    click(EXPORT_DATE_RANGE_SELECT_LIST)
    click(EXPORT_DATE_RANGE_CHOICE)
  end

  def fill_export_form
    select_export_source
    select_export_type
    select_comparison_field
    select_date_range
  end

  def submit_export_form
    click(SUBMIT_BUTTON)
  end

  def has_pending?
    text_include?('Pending', {css: '.exports-table'})
  end
end
