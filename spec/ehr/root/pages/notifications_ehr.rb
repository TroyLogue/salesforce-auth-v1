# frozen-string-literal: true

require_relative '../../../shared_components/base_page'

class NotificationsEhr < BasePage
  NOTIFICATION_BODY = { css: '.Toastify__toast-body' }.freeze
  ERROR_NOTIFICATION = { css: '.Toastify__toast--error' }.freeze
  SUCCESS_NOTIFICATION = { css: '.Toastify__toast--success' }.freeze
  CLOSE_BTN = { css: '.Toastify__close-button' }.freeze

  #TODO remove, once https://uniteus.atlassian.net/browse/CPR-303 is complete
  ASSESSMENT_SUCCESS_NOTIFICATION = { css: '.notification.success' }.freeze
  ASSESSMENT_NOTIFICATION_BODY = { css: '.notification__text-header' }.freeze

  # Messages:
  MESSAGE_SENT = 'Message successfully sent'
  ASSESSMENT_UPDATED = "ASSESSMENT SUCCESSFULLY EDITED"

  def close_notification
    is_displayed?(SUCCESS_NOTIFICATION) &&
      click_within(SUCCESS_NOTIFICATION, CLOSE_BTN)
  end

  def error_notification_not_displayed?
    is_not_displayed?(ERROR_NOTIFICATION)
  end

  def error_text
    is_displayed?(ERROR_NOTIFICATION) &&
      text(NOTIFICATION_BODY)
  end

  def success_text
    is_displayed?(SUCCESS_NOTIFICATION) &&
      text(NOTIFICATION_BODY)
  end

  #TODO remove, once https://uniteus.atlassian.net/browse/CPR-303 is complete
  def assessment_success_text
    is_displayed?(ASSESSMENT_SUCCESS_NOTIFICATION) &&
      text(ASSESSMENT_NOTIFICATION_BODY)
  end
end
