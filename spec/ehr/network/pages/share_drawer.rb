# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ShareDrawer < BasePage
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn.ui-drawer__close-btn--opened' }
  EMAIL_INPUT = { css: '#share-email-field' }
  HEADER = { css: '.share-drawer__header' }
  OPENED_DRAWER = { css: '.ui-drawer--opened.share-drawer' }
  PHONE_INPUT = { css: '#share-phone-field' }
  PRINT_BTN = { css: '#share-print-button' }
  PROVIDER_LIST = { css: '.share-drawer-list' }
  SHARE_BY_SMS = { css: "#sms-label" }
  SHARE_BY_EMAIL = { css: "#email-label" }
  SHARE_BY_PRINT = { css: "#print-label" }
  SHARE_FORM = { css: '#network-browse-share-form' }
  SHARE_SEND_BTN = { css: '#share-send-button' }
  VALID_PHONE_NUMBER = '2129999999'

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def header_text
    text(HEADER)
  end

  def page_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(HEADER) &&
      is_displayed?(SHARE_FORM) &&
      is_displayed?(SHARE_BY_SMS) &&
      is_displayed?(SHARE_BY_EMAIL) &&
      is_displayed?(SHARE_BY_PRINT) &&
      is_displayed?(PROVIDER_LIST)
  end

  def provider_list_text
    text(PROVIDER_LIST)
  end

  def share_by_email(email)
    click(SHARE_BY_EMAIL)
    enter(email, EMAIL_INPUT)
    click(SHARE_SEND_BTN)
  end

  def share_by_sms(phone_number)
    click(SHARE_BY_SMS)
    enter(phone_number, PHONE_INPUT)
    click(SHARE_SEND_BTN)
  end

  def share_by_print
    click(SHARE_BY_PRINT)
    click(PRINT_BTN)
  end
end
