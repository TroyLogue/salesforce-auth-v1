# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Banner < BasePage
  SYSTEM_ALERT = { css: '.system-alert-banner__text-container' }.freeze
  DISMISS_SYSTEM_ALERT_BUTTON = { id: 'system-alert-banner-dismiss-btn' }.freeze

  # UU3-49164 workaround for banner blocking drawer elements
  def dismiss_alert_if_displayed
    click(DISMISS_SYSTEM_ALERT_BUTTON) if is_displayed?(SYSTEM_ALERT)
  end
end
