require_relative '../../../shared_components/base_page'

class NetworkBrowseDrawer < BasePage

  # navigation
  OPENED_DRAWER = { css: '.ui-drawer--opened.browse__drawer .network-group-details.group-details' }
  CLOSE_BUTTON = { css: '.ui-drawer__close-btn--opened .ui-icon' }

  SHARE_BUTTON = { css: '#network-groups-drawer-share-btn' }

  # provider details
  PROVIDER_DETAILS_MAP = { css: '.group-details-content__map' }
  PROVIDER_DETAILS_DESCRIPTION = { css: '#detail-description-expandable' }
  PROVIDER_DETAILS_CONTACT = { css: '.group-details-content__contact' }
  PROVIDER_DETAILS_HOURS = { css: '.group-details-content__hours' }
  PROVIDER_DETAILS_PROGRAMS = { css: '.group-details-content__programs' }

  # program details
  PROGRAM_DETAILS_SERVICES = { css: '.program-details .ui-service-types' }

  # share form
  SHARE_FORM = { css: '.expandable-container__content.open .share-form' }

  SHARE_VIA_PHONE_OPTION = { css: '#sms-label' }
  PHONE_INPUT = { css: '#share-phone-field' }
  SHARE_VIA_EMAIL_OPTION = { css: '#email-label' }
  EMAIL_INPUT = { css: '#share-email-field' }
  SEND_BUTTON = { css: '#share-send-button' }

  SHARE_VIA_PRINT_OPTION = { css: '#print-label' }
  PRINT_BUTTON = { css: '#share-print-button' }
  CANCEL_BUTTON = { css: '#share-cancel-button' }

  def click_share_button
    click(SHARE_BUTTON)
  end

  def close_drawer
    click(CLOSE_BUTTON)
  end

  def drawer_displayed?
    sleep(1) #waiting for slide in animation
    is_displayed?(OPENED_DRAWER) &&
    is_displayed?(CLOSE_BUTTON) &&
    is_displayed?(SHARE_BUTTON) &&

    is_displayed?(PROVIDER_DETAILS_MAP) &&
    is_displayed?(PROVIDER_DETAILS_DESCRIPTION) &&
    is_displayed?(PROVIDER_DETAILS_CONTACT) &&
    is_displayed?(PROVIDER_DETAILS_PROGRAMS) &&
    is_displayed?(PROGRAM_DETAILS_SERVICES)
  end

  def drawer_not_displayed?
    is_not_displayed?(OPENED_DRAWER)
  end

  def share_form_displayed?
    is_displayed?(SHARE_FORM)
  end

  def share_provider_details_via_email(address)
    click(SHARE_VIA_EMAIL_OPTION)
    click(EMAIL_INPUT)
    enter(address, EMAIL_INPUT)
    click(SEND_BUTTON)
    wait_for_spinner
  end
end
