# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ProviderDrawer < BasePage
  ADD_BTN = { css: '#group-title__add-btn' }
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn > a > .ui-icon' }
  CONTACT_INFO = { css: '.group-details__contact-info-contact' }
  DESCRIPTION = { css: '.group-details__description' }
  EMAIL_INPUT = { css: '#share-email-field' }
  OPENED_DRAWER = { css: '.ui-drawer--opened' }
  PROGRAMS = { css: '.group-details__programs' }
  MAP = { css: '.map' }
  SERVICES_PROVIDED = { css: '.group-details__service-types' }
  SHARE_BY_SMS = { css: ".ui-radio-field__item [value='sms']" }
  SHARE_BY_EMAIL = { css: ".ui-radio-field__item [value='email']" }
  SHARE_BY_PRINT = { css: ".ui-radio-field__item [value='print']" }
  SHARE_BTN = { css: '#group-title__share-btn' }
  SHARE_FORM = { css: '#group-details-share-form' }
  SHARE_CONTAINER_OPEN = { css: '.group-details__send-provider .expandable-container__content.open' }
  SHARE_CANCEL_BTN = { css: '#share-cancel-button' }
  SHARE_SEND_BTN = { css: '#share-send-button' }
  TITLE = { css: '.group-title__text--name' }

  def click_share
    click(SHARE_BTN)
  end

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def page_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(TITLE) &&
      is_displayed?(SHARE_BTN) &&
      is_displayed?(ADD_BTN) &&
      is_displayed?(MAP) &&
      is_displayed?(DESCRIPTION) &&
      is_displayed?(CONTACT_INFO) &&
      is_displayed?(SERVICES_PROVIDED) &&
      is_displayed?(PROGRAMS)
  end

  def provider_name
    text(TITLE)
  end

  def share_by_email(email)
    click(SHARE_BY_EMAIL)
    enter(email, EMAIL_INPUT)
    click(SHARE_SEND_BTN)
  end

  def share_section_displayed?
    is_displayed?(SHARE_CONTAINER_OPEN) &&
      is_displayed?(SHARE_FORM) &&
      is_displayed?(SHARE_BY_SMS) &&
      is_displayed?(SHARE_BY_EMAIL) &&
      is_displayed?(SHARE_BY_PRINT)
  end
end
