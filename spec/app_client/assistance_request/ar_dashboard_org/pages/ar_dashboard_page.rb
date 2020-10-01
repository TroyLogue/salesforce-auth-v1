require_relative '../../../../shared_components/base_page'

class DashboardPage < BasePage
  TAKE_ACTION = { css: '.choices__item' }
  START_INTAKE_CHOICE = { css: '#choices-assistance-request-action-select-item-choice-2' }
  FACESHEET_LINK = { css: '.contact-column-details__link' }
  
  def select_start_intake_action
    click(TAKE_ACTION)
    click(START_INTAKE_CHOICE)
  end

  def facesheet_link_text
    find(FACESHEET_LINK).text
  end
end