# frozen-string-literal: true

require_relative '../../../shared_components/base_page'

class NotificationsEhr < BasePage
  NOTIFICATION = { css: '.notifications' }
  NOTIFICATION_TEXT_DIV = { css: '.notification__text' }
  ERROR_NOTIFICATION = { css: '.notifications .notification.error.fade-enter-done' }
  SUCCESS_NOTIFICATION = { css: '.notifications .notification.success.fade-enter-done' }
  CLOSE_BTN = { css: 'notification__close-btn' }

  MESSAGE_SENT = 'Message successfully sent'

  def close_notification
    is_displayed?(SUCCESS_NOTIFICATION)
    click_within(SUCCESS_NOTIFICATION, CLOSE_BTN)
  end

  def error_text
    find(ERROR_NOTIFICATION)
    return text(NOTIFICATION_TEXT_DIV)
  end

  def success_text
    find(SUCCESS_NOTIFICATION)
    return text(NOTIFICATION_TEXT_DIV)
  end
end
