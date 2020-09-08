require_relative '../../../shared_components/base_page'

class FacesheetHeader < BasePage
  NAME_HEADER = { css: '.status-select__full-name.display' }
  OVERVIEW_TAB = { css: '#facesheet-overview-tab' }
  PROFILE_TAB = { css: '#facesheet-profile-tab' }
  CASES_TAB = { css: '#facesheet-cases-tab' }
  FORMS_TAB = { css: '#facesheet-forms-tab' }
  UPLOADS_TAB = { css: '#facesheet-uploads-tab' }
  REFERALS_TAB = { css: '#facesheet-referrals-tab' }
  NOTIFICATION_SUCCESS = {css: 'div.notification.success'}
  FACESHEET_ASSESSMENTS = {css: '.facesheet-assessments'}

  def page_displayed?
    is_displayed?(FILTER_BAR)
    wait_for_spinner
  end

  def get_facesheet_name
    text(NAME_HEADER)
  end

  def go_to_uploads
    click(UPLOADS_TAB)
    wait_for_spinner
  end

  def go_to_overview
    click(OVERVIEW_TAB)
    wait_for_spinner
  end

  def go_to_profile
    click(PROFILE_TAB)
    wait_for_spinner
  end

  def go_to_facesheet_with_contact_id(id:, tab: '')
    get("/facesheet/#{id}/#{tab}")
  end

  def go_to_forms
    click(FORMS_TAB)
    wait_for_spinner 
  end

  def green_ribbon_displayed?
    is_displayed?(NOTIFICATION_SUCCESS)
  end

  def assessments_displayed?
    is_displayed?(FACESHEET_ASSESSMENTS)
    end

end
