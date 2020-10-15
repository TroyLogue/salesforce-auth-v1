require_relative '../../../../shared_components/base_page'

class AsistanceRequest < BasePage
  TAKE_ACTION = { css: '.choices__item' }.freeze
  START_INTAKE_CHOICE = { css: '#choices-assistance-request-action-select-item-choice-2' }.freeze
  
  def go_to_new_ar_with_id(ar_id:)
    get("/dashboard/new/assistance-requests/#{ar_id}")
    wait_for_spinner
  end
  
  def select_start_intake_action
    click(TAKE_ACTION)
    click(START_INTAKE_CHOICE)
  end
end