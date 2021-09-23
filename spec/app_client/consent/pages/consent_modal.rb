# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ConsentModal < BasePage
  CONSENT_MODAL = { css: '#consent-dialog.dialog.open.jumbo' }.freeze
  CONSENT_CLOSE_BTN = { css: '#consent-dialog.dialog.open.jumbo a[role="button"]' }.freeze
  EMAIL_RADIO_BTN = { css: '#email_address-label' }.freeze
  EMAIL_INPUT_FIELD = { css: '#email-address' }.freeze
  EMAIL_SUBMIT_BTN = { css: '#consent-submit-email-btn' }.freeze

  DOCUMENT_UPLOAD_RADIO_BTN = { css: '#document-label' }.freeze
  AUDIO_UPLOAD_RADIO_BTN = { css: '#audio-0' }.freeze

  CONSENT_FILE_PATH = 'lib/files/fakeConsent.txt'
  PAPER_VERBAL_FILE_INPUT = { css: '#Consent > section > div > input[type=file]' }.freeze
  PAPER_VERBAL_SUBMIT_BTN = { css: '#audio-document-consent-btn' }.freeze

  ON_SCREEN_CONSENT_RADIO_BTN = { css: '#on_screen-label' }.freeze
  GO_TO_FORM = { css: '#go-to-form-btn' }.freeze
  LOADING_SPINNER = { css: '.overlay-spinner__text' }.freeze
  CONSENT_IFRAME = { css: '#consent-app-frame-iframe' }.freeze
  SIGNATURE_BOX = { css: '#signature-canvas' }.freeze
  ACCEPT_BTN = { css: '#accept' }.freeze

  PHONE_NUMBER_RADIO_BTN = { css: '#phone_number-label' }.freeze
  PHONE_NUMBER_INPUT_FIELD = { css: '#phone-number' }.freeze
  PHONE_NUMBER_SUBMIT_BTN = { css: '#consent-submit-phone-btn' }.freeze
  VALID_PHONE_NUMBER = '2129999999'

  def page_displayed?
    is_displayed?(CONSENT_MODAL) &&
      is_displayed?(CONSENT_CLOSE_BTN)
  end

  def phone_value
    value(PHONE_NUMBER_INPUT_FIELD)
  end

  def email_value
    value(EMAIL_INPUT_FIELD)
  end

  def go_to_form_button_displayed?
    is_displayed?(GO_TO_FORM)
  end

  def submit_button_displayed?
    is_displayed?(PAPER_VERBAL_SUBMIT_BTN)
  end

  def add_consent_by_document_upload
    click(DOCUMENT_UPLOAD_RADIO_BTN)
    filename = CONSENT_FILE_PATH
    file = File.join(Dir.pwd, filename)
    enter(file, PAPER_VERBAL_FILE_INPUT)
    click(PAPER_VERBAL_SUBMIT_BTN)
  end

  def add_on_screen_consent
    click(ON_SCREEN_CONSENT_RADIO_BTN)
    click(GO_TO_FORM)
    is_not_displayed?(LOADING_SPINNER)

    scroll_down_consent(CONSENT_IFRAME)

    driver.action.move_by(500, 500).perform
    driver.action.click_and_hold.perform
    driver.action.move_by(50, 0).perform
    driver.action.click.perform

    switch_to(CONSENT_IFRAME)
    click_via_js(ACCEPT_BTN)
  end

  def select_consent_by_email
    click(EMAIL_RADIO_BTN)
  end

  def request_consent_by_email(address)
    click(EMAIL_RADIO_BTN)
    click(EMAIL_INPUT_FIELD)
    clear_then_enter(address, EMAIL_INPUT_FIELD)
    click(EMAIL_SUBMIT_BTN)
  end

  def select_consent_by_text
    click(PHONE_NUMBER_RADIO_BTN)
  end

  def request_consent_by_text(phone_number)
    click(PHONE_NUMBER_RADIO_BTN)
    10.times { delete_char(PHONE_NUMBER_INPUT_FIELD) }
    enter(phone_number, PHONE_NUMBER_INPUT_FIELD)
    click(PHONE_NUMBER_SUBMIT_BTN)
    wait_for_spinner
  end

  # needs debugging on firefox
  def scroll_down_consent(selector)
    consent_box = find(selector)

    # can't use js commands on this iframe - it throws a security error
    # increased initial scroll downs from 5 to 30 to work w chrome
    30.times do # chrome is giving a hard time with scrolling
      consent_box.send_keys :page_down
    end

    sleep(1) # wait for animation
  end

  def close_consent_modal
    click(CONSENT_CLOSE_BTN)
    wait_for_element_to_disappear(CONSENT_MODAL)
  end
end
