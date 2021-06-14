# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NetworkBrowseDrawer < BasePage
  # navigation
  OPENED_DRAWER = { css: '.ui-drawer--opened .network-group-details.group-details' }.freeze
  CLOSE_BUTTON = { css: '.ui-drawer__close-btn--opened .ui-icon' }.freeze

  SHARE_BUTTON = { css: '#network-groups-drawer-share-btn' }.freeze
  EDIT_BTN = { css: '#network-groups-drawer-edit-btn' }.freeze

  # provider details
  # required fields:
  PROVIDER_DETAILS_MAP = { css: '.group-details-content__map' }.freeze
  PROVIDER_DETAILS_DESCRIPTION = { css: '#detail-description-expandable' }.freeze
  PROVIDER_DETAILS_LOCATION_HEADER = { css: '.provider-content-v2__location-header' }.freeze
  PROVIDER_DETAILS_ADDRESS = { css: '.ui-provider-card__address' }.freeze
  PROVIDER_DETAILS_HOURS = { css: '.ui-provider-card__hours' }.freeze
  PROVIDER_DETAILS_PROGRAMS = { css: '.group-details-content__programs' }.freeze

  # optional fields:
  PROVIDER_DETAILS_PHONE = { css: '.ui-provider-card__phone' }.freeze
  PROVIDER_DETAILS_EMAIL = { css: '.ui-provider-card__email' }.freeze
  PROVIDER_DETAILS_WEBSITE = { css: '.ui-provider-card__website' }.freeze

  TOGGLE_MORE_INFO = { css: '#more-or-less-toggle-btn' }.freeze

  # program details
  PROGRAM_DETAILS_SERVICES = { css: '.program-card-v2 .ui-service-types' }.freeze

  # share form
  SHARE_FORM = { css: '.expandable-container__content.open .share-form' }.freeze
  SHARE_VIA_PHONE_OPTION = { css: '#sms-label' }.freeze
  PHONE_INPUT = { css: '#share-phone-field' }.freeze
  SHARE_VIA_EMAIL_OPTION = { css: '#email-label' }.freeze
  EMAIL_INPUT = { css: '#share-email-field' }.freeze
  SHARE_VIA_PRINT_OPTION = { css: '#print-label' }.freeze
  PRINT_BUTTON = { css: '#share-print-button' }.freeze
  CANCEL_BUTTON = { css: '#share-cancel-button' }.freeze
  SEND_BUTTON = { css: '#share-send-button' }.freeze

  # Edit form
  EDIT_FORM = { css: '.oon-group-form' }.freeze
  EDIT_PHONE_INPUT = { css: '#phone-number-main-field' }.freeze
  SAVE_BTN = { css: '#oon-group-form-save-btn' }.freeze

  # test inputs:
  # cf. https://www.twilio.com/blog/2018/04/twilio-test-credentials-magic-numbers.html
  INVALID_PHONE_NUMBER = '(999) 999-9999'
  VALID_PHONE_NUMBER = '15005550006'

  def click_share_button
    click(SHARE_BUTTON)
  end

  def close_drawer
    click(CLOSE_BUTTON)
  end

  def drawer_displayed?
    sleep(1) #waiting for slide in animation
    is_displayed?(OPENED_DRAWER) &&
    is_displayed?(CLOSE_BUTTON) &&
    is_displayed?(SHARE_BUTTON) &&

    is_displayed?(PROVIDER_DETAILS_MAP) &&
    is_displayed?(PROVIDER_DETAILS_DESCRIPTION) &&
    is_displayed?(PROVIDER_DETAILS_LOCATION_HEADER) &&
    is_displayed?(PROVIDER_DETAILS_ADDRESS) &&
    is_displayed?(PROVIDER_DETAILS_HOURS) &&
    is_displayed?(PROVIDER_DETAILS_PROGRAMS) &&
    is_displayed?(PROGRAM_DETAILS_SERVICES)
  end

  def drawer_not_displayed?
    is_not_displayed?(OPENED_DRAWER)
  end

  def share_form_displayed?
    is_displayed?(SHARE_FORM)
  end

  def share_provider_details_via_email(address)
    click(SHARE_VIA_EMAIL_OPTION)
    click(EMAIL_INPUT)
    enter(address, EMAIL_INPUT)
    click(SEND_BUTTON)
    wait_for_spinner
  end

  def share_provider_details_via_phone(phone)
    click(SHARE_VIA_PHONE_OPTION)
    click(PHONE_INPUT)
    enter(phone, PHONE_INPUT)
    click(SEND_BUTTON)
    wait_for_spinner
  end

  def can_edit_provider?
    is_displayed?(EDIT_BTN)
  end

  def edit_and_save_provider_phone_number(number:)
    click(EDIT_BTN)
    clear_then_enter(number, EDIT_PHONE_INPUT)
    click(SAVE_BTN)
  end
end
