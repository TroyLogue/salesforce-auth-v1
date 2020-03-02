require_relative '../../../shared_components/base_page'

class Exports < BasePage
  NEW_EXPORT_BUTTON = { css: '#create-new-export-btn' }
  SELECT_1 = { css: '.export-create-fields__select:nth-of-type(1)' }
  CHOICE_1 = { css: '#choices-export-create-input__type-item-choice-1' }
  SELECT_2 = { css: '.export-create-fields__select:nth-of-type(2)' }
  CHOICE_2 = CHOICE_1
  SELECT_3 = { css: '.export-create-fields__select:nth-of-type(3)' }
  CHOICE_3 = { css: '#choices-export-create-input__filter-item-choice-1' }
  SELECT_4 = { css: '.export-create-fields__select:nth-of-type(4)' }
  CHOICE_4 = { css: '#choices-export-create-input__period-item-choice-2' }
  SUBMIT_BUTTON = { css: '#form-footer-submit-btn' }

  def page_displayed?
    is_displayed?(NEW_EXPORT_BUTTON)
  end

  def click_new_export
    click(NEW_EXPORT_BUTTON)
  end

  def fill_export_form
    click(SELECT_1)
    click(CHOICE_1)
    get_active_element().send_keys(:tab)
    click(SELECT_2)
    click(CHOICE_2)
    get_active_element().send_keys(:tab)
    click(SELECT_3)
    click(CHOICE_3)
    click(SELECT_4)
    click(CHOICE_4)
  end

  def submit_export_form
    click(SUBMIT_BUTTON)
  end

  def has_pending?
    text_include?('Pending', {css: '.exports-table'})
  end
end
