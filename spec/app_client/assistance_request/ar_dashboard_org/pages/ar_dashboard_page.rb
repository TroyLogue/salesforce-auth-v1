require_relative '../../../../shared_components/base_page'

class AsistanceRequest < BasePage
  TAKE_ACTION = { css: '.choices__item' }.freeze
  START_INTAKE_CHOICE = { css: '#choices-assistance-request-action-select-item-choice-2' }.freeze
  FACESHEET_LINK = { css: '.contact-column-details__link' }.freeze
  FIRSTNAME_INPUT = { css: '#first-name' }.freeze
  LASTNAME_INPUT = { css: '#last-name' }.freeze
  INTAKE_CONTEXT = { css: '.entry-context' }.freeze
  AR_DETAILS_PAGE = { css: ".assistance-request-detail-view" }.freeze
  SUCCESS_BANNER = { css: '.notification.success.velocity-animating' }.freeze
  
  def go_to_new_ar_with_id(ar_id:)
    get("/dashboard/new/assistance-requests/#{ar_id}")
    wait_for_spinner
  end
  
  def select_start_intake_action
    click(TAKE_ACTION)
    click(START_INTAKE_CHOICE)
  end

  def intake_created_text
    text(INTAKE_CONTEXT)
  end

  def ar_details_page_displayed?
    is_displayed?(AR_DETAILS_PAGE) &&
    is_not_displayed?(SUCCESS_BANNER)
  end
end