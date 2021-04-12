require_relative '../../../../lib/file_helper'

class ReferralSend < BasePage
  SEND_REFERRAL_FORM = { css: '.send-referral-form' }.freeze

  SELECTED_SERVICE_TYPE = { css: '#service-type + div' }.freeze
  ADD_ANOTHER_RECIPIENT = { css: 'button[aria-label="+ ADD ANOTHER RECIPIENT"]' }.freeze
  ERROR_MESSAGE = { css: '.field-error-message > p' }.freeze

  SUGGESTED_ORG_SECTION = { css: '.referral-groups-programs' }.freeze
  BROWSE_MAP_LINK = { css: '#browse-map-button' }.freeze
  SELECTED_ORG_DROPDOWN = { css: '.referral-group-select div[aria-selected="true"]' }.freeze
  SEND_REFERRAL_BTN = { css: '#send-referral-send-btn' }.freeze

  EXPAND_ORG_CHOICES = { css: 'div[aria-activedescendant^="choices-select-field-group"]' }.freeze
  FIRST_ORG_CHOICE = { css: '#choices-select-field-group-0-item-choice-2' }.freeze

  ERROR_MULTIPLE_RECIPIENT_CC = 'A referral with multiple recipients cannot include a Coordination Center. Refer to a Coordination Center only if you are uncertain about which organization(s) can serve your client.'.freeze

  def page_displayed?
    @recipient_index = 0
    is_displayed?(SEND_REFERRAL_FORM) &&
      is_displayed?(SUGGESTED_ORG_SECTION)
  end

  def open_network_browse_map
    click(BROWSE_MAP_LINK)
  end

  def select_first_org
    org_choices = { css: "#select-field-group-#{@recipient_index} + .choices__list" }
    first_org_choice = { css: "div[id^='choices-select-field-group-#{@recipient_index}-item-choice']:not([aria-disabled*='true']):not([data-value=''])" }

    click(org_choices)
    click(first_org_choice)

    if is_displayed?(ERROR_MESSAGE, 2) && text(ERROR_MESSAGE) == ERROR_MULTIPLE_RECIPIENT_CC
      info_message = 'Users are unable to add a Coordination Center when there are multiple recipients. '\
                     'One of the providers selected is a Coordination Center.'
      raise StandardError, info_message
    end

    selected_organization
  end

  def selected_organization
    selected_org = { css: "#select-field-group-#{@recipient_index} + div > div:not(button)" }

    # Removing distance and "Remove Item" to return just the provider name
    provider = text(selected_org)
    provider_distance = provider.rindex(/\(/) # finds the last open paren in the string
    provider[0..(provider_distance - 1)].strip # returns provider_text up to the distance
  end

  def add_another_recipient
    click(ADD_ANOTHER_RECIPIENT)
    @recipient_index += 1
    org_choices = { css: "#select-field-group-#{@recipient_index} + .choices__list" }

    is_displayed?(org_choices)
  end

  def add_multiple_recipients(count:)
    recipient_info = []
    count.times do
      provider = select_first_org
      recipient_info << provider
      add_another_recipient
    end
    recipient_info
  end

  def send_referral
    click(SEND_REFERRAL_BTN)
    time = Time.now.strftime('%l:%M %P').strip
    wait_for_spinner
    time
  end
end
