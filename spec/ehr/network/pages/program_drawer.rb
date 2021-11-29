# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ProgramDrawer < BasePage
  ADD_BTN = { css: '[id^=add-program-btn-]' }
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn.ui-drawer__close-btn--opened a' }
  DESCRIPTION_HEADER = { xpath: './/div[text()="Description"]' }
  OPENED_DRAWER = { css: '.ui-drawer--opened' }
  ORG_CONTACT_INFO_HEADER = { xpath: './/div[text()="Organization Contact Info"]' }
  PROGRAM_TITLE = { css: 'div[data-qa=details-drawer-container] > div:nth-child(2) > div:nth-child(1)' }
  PROVIDER_TITLE = { css: 'div[data-qa=details-drawer-container] > div:nth-child(2) > div:nth-child(2)' }

  def add_program
    click(ADD_BTN)
  end

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def page_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(PROGRAM_TITLE) &&
      is_displayed?(PROVIDER_TITLE) &&
      is_displayed?(ADD_BTN) &&
      is_displayed?(DESCRIPTION_HEADER) &&
      is_displayed?(ORG_CONTACT_INFO_HEADER)
  end

  def program_name
    text(PROGRAM_TITLE)
  end

  def provider_name
    text(PROVIDER_TITLE)
  end
end
