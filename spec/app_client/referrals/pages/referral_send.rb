require_relative '../../../../lib/file_helper'

class SendReferral < BasePage
  SEND_REFERRAL_FORM = { css: '.send-referral-form' }

  SUGGESTED_ORG_SECTION = { css: '.referral-groups-programs' }
  BROWSE_MAP_LINK = { css: '#browse-map-button' }
  SELECTED_ORG_DROPDOWN = { css: '.referral-group-select div[aria-selected="true"]' }
  SEND_REFERRAL_BTN = { css: '#send-referral-send-btn' }

  def page_displayed?
    is_displayed?(SEND_REFERRAL_FORM) &&
    is_displayed?(SUGGESTED_ORG_SECTION)
  end

  def open_network_browse_map
    click(BROWSE_MAP_LINK)
  end

  def selected_organization
    # Removing excess text
    text(SELECTED_ORG_DROPDOWN).gsub("\nRemove item", "")
  end

  def send_referral
    click(SEND_REFERRAL_BTN)
    wait_for_spinner
  end
end
