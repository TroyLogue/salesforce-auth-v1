# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FacesheetHeader < BasePage
  SUBHEADER = { css: '.facesheet-index__subheader-container' }.freeze
  NAME_HEADER = { css: '.status-select__full-name.display' }.freeze
  OVERVIEW_TAB = { css: '#facesheet-overview-tab' }.freeze
  PROFILE_TAB = { css: '#facesheet-profile-tab' }.freeze
  CASES_TAB = { css: '#facesheet-cases-tab' }.freeze
  FORMS_TAB = { css: '#facesheet-forms-tab' }.freeze
  UPLOADS_TAB = { css: '#facesheet-uploads-tab' }.freeze
  REFERALS_TAB = { css: '#facesheet-referrals-tab' }.freeze

  REFER_CLIENT = { css: '#subheader-refer-btn' }.freeze
  CONSENT_STATUS = { css: '#status-select-options > option' }.freeze
  EXPAND_CONSENT_OPTIONS = { css: '#status-select-options + div' }.freeze
  LIST_CONSENT_OPTIONS = { css: 'div[id^="choices-status"]' }.freeze

  SEND_SMS = 'Send SMS'
  SEND_EMAIL = 'Send Email'
  REQUEST_ONSCREEN = 'Request On-Screen'
  UPLOAD_PAPER = 'Upload Signed Paper'
  UPLOAD_AUDIO = 'Upload Audio File'
  PROVIDE_ATTESTATION = 'Provide Attestation'
  VIEW = 'View'

  def page_displayed?
    is_displayed?(SUBHEADER)
    wait_for_spinner
  end

  def facesheet_name
    text(NAME_HEADER)
  end

  def consent_status
    attribute(CONSENT_STATUS, 'textContent')
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

  def go_to_cases
    click(CASES_TAB)
    wait_for_spinner
  end

  def go_to_facesheet_with_contact_id(id:, tab: '')
    get("/facesheet/#{id}/#{tab}")
  end

  def go_to_forms
    click(FORMS_TAB)
    wait_for_spinner
  end

  def select_consent_option(option:)
    click(EXPAND_CONSENT_OPTIONS)
    click_element_from_list_by_text(LIST_CONSENT_OPTIONS, option)
  end

  def refer_client
    click(REFER_CLIENT)
  end
end
