# frozen-string-literal: true

class Notifications < BasePage
  NOTIFICATION = { css: '.notifications' }
  ERROR_NOTIFICATION = { css: '.notifications .notification.error' }
  SUCCESS_NOTIFICATION = { css: '.notifications .notification.success' }
  CLOSE_BTN = { css: 'notification__close-btn' }

  MESSAGE_SENT = 'Message successfully sent'

  def error_text
    find(ERROR_BANNER)
    return text(NOTIFICATION_BANNER)
  end

  def success_text
    find(SUCCESS_BANNER)
    return text(NOTIFICATION_BANNER)
  end

  def close_notification
    is_displayed?(SUCCESS_BANNER)
    click_within(SUCCESS_BANNER, CLOSE_BTN)
  end
end
