# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Notifications < BasePage
  NOTIFICATION_BANNER = { css: '#notifications' }.freeze
  ERROR_BANNER = { css: '#notifications .notification.error' }.freeze
  SUCCESS_BANNER = { css: '#notifications .notification.success' }.freeze
  CLOSE_BANNER = { css: '.close' }.freeze

  ACCESS_DENIED = 'Access to the requested resource has been forbidden.'
  ASSISTANCE_REQUEST_CLOSED = 'Assistance Request Successfully Closed'
  BLANK_EMAIL_MESSAGE = "EmailAddress can't be blank"
  CASE_CREATED = 'Case Created'
  CASE_REOPENED = 'Case Successfully Reopened'
  CLIENT_UPDATED = 'Client Successfully Updated'
  CONSENT_REQUEST_SENT = 'Consent Request Sent'
  CONSENT_UPLOADED = 'Consent Uploaded'
  EMAIL_ADDRESS_UPDATED = 'Email Address Successfully Updated'
  GROUP_UPDATED = 'Group Successfully Updated'
  INTAKE_CREATED = 'Intake Successfully Created'
  MESSAGE_SENT = 'Message successfully sent'
  NOTE_ADDED = 'Note Successfully Added'
  ORG_UPDATED = 'Organization Updated'
  PHONE_NUMBER_INVALID = "Twilio verification for 'to' number"
  PHONE_NUMBER_UPDATED = 'Phone Number Successfully Updated'
  PROGRAM_UPDATED = 'Program Successfully Updated'
  REFERRAL_ACCEPTED = 'Referral Acceptance Successful'
  REFERRAL_CLOSED = 'Referral Successfully Closed'
  REFERRAL_CREATED = 'Referral Successfully Created'
  REFERRAL_HELP = 'Referral Held Successfully'
  REFERRAL_REJECTED = 'Referral Rejected Successfully'
  REFERRAL_SENT = 'Referral Successfully Sent Out'
  SETTINGS_UPDATED = 'Successfully Updated Settings'
  SUPPORTING_ASSESSMENT_SAVED = 'Supporting Assessments Successfully Saved'
  INSECURE_PASSWORD = 'Password is not safe to use as it appears in a list of weak passwords. Please change your password to something more secure.'
  USER_UPDATED = 'User Successfully Updated'

  def error_text
    find(ERROR_BANNER)
    text(NOTIFICATION_BANNER)
  end

  def success_text
    find(SUCCESS_BANNER)
    text(NOTIFICATION_BANNER)
  end

  def close_banner
    is_displayed?(SUCCESS_BANNER)
    click_within(SUCCESS_BANNER, CLOSE_BANNER)
  end

  def notification_not_displayed?
    is_not_displayed?(ERROR_BANNER)
  end
end
