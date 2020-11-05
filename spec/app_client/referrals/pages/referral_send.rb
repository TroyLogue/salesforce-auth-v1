require_relative '../../../../lib/file_helper'

class ReferralSend < BasePage
  SEND_REFERRAL_FORM = { css: '.send-referral-form' }.freeze

  SUGGESTED_ORG_SECTION = { css: '.referral-groups-programs' }.freeze
  BROWSE_MAP_LINK = { css: '#browse-map-button' }.freeze
  SELECTED_ORG_DROPDOWN = { css: '.referral-group-select div[aria-selected="true"]' }.freeze
  SEND_REFERRAL_BTN = { css: '#send-referral-send-btn' }.freeze

  def page_displayed?
    is_displayed?(SEND_REFERRAL_FORM) &&
      is_displayed?(SUGGESTED_ORG_SECTION)
  end

  def open_network_browse_map
    click(BROWSE_MAP_LINK)
  end

  def selected_organization
    # Removing distance and "Remove Item" to return just the provider name
    provider_text = text(SELECTED_ORG_DROPDOWN)
    provider_distance_index = text(SELECTED_ORG_DROPDOWN).rindex(/\(/) # finds the last open paren in the string
    provider_text[0..(provider_distance_index - 1)].strip # returns provider_text up to the distance
  end

  def send_referral
    click(SEND_REFERRAL_BTN)
    time = Time.now.strftime('%l:%M %P').strip
    wait_for_spinner
    time
  end
end
