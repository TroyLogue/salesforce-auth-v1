require_relative '../../../../lib/file_helper'

class SendReferral < BasePage
  SEND_REFERRAL_FORM = { css: '.send-referral-form' }
  SUGGESTED_ORG = { css: '.referral-groups-programs' }
  BROWSE_MAP_LINK = { css: 'browse-map-button' }

  def page_displayed?
    is_displayed?(SEND_REFERRAL_FORM) &&
    is_displayed?(SUGGESTED_ORG)
  end

  def open_network_browse_map
    click(BROWSE_MAP_LINK)
    wait_for_spinner
  end
end
