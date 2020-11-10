# frozen-string-literal: true

require_relative '../../../shared_components/base_page'

class NotificationsEhr < BasePage
  NOTIFICATION = { css: '.notifications' }.freeze
  NOTIFICATION_TEXT_DIV = { css: '.notification__text' }.freeze
  ERROR_NOTIFICATION = { css: '.notifications .notification.error.fade-enter-done' }.freeze
  SUCCESS_NOTIFICATION = { css: '.notifications .notification.success.fade-enter-done' }.freeze
  CLOSE_BTN = { css: 'notification__close-btn' }.freeze

  MESSAGE_SENT = 'Message successfully sent'

  def close_notification
    is_displayed?(SUCCESS_NOTIFICATION)
    click_within(SUCCESS_NOTIFICATION, CLOSE_BTN)
  end

  def error_notification_not_displayed?
    is_not_displayed?(ERROR_NOTIFICATION)
  end

  def error_text
    find(ERROR_NOTIFICATION)
    text(NOTIFICATION_TEXT_DIV)
  end

  def success_text
    find(SUCCESS_NOTIFICATION)
    text(NOTIFICATION_TEXT_DIV)
  end
end
