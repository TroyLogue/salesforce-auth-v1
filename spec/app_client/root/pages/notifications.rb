require_relative '../../../shared_components/base_page'

class Notifications < BasePage

  NOTIFICATION_BANNER = { css: '#notifications' }
  ERROR_BANNER = { css: '#notifications .notification.error' }
  SUCCESS_BANNER = { css: '#notifications .notification.success' }
  CLOSE_BANNER = { css: '.close' }

  BLANK_EMAIL_MESSAGE = "EmailAddress can't be blank"
  CASE_CREATED = 'Case Created'
  CLIENT_UPDATED = 'Client Successfully Updated'
  CONSENT_REQUEST_SENT = 'Consent Request Sent'
  CONSENT_UPLOADED = 'Consent Uploaded'
  EMAIL_ADDRESS_UPDATED = 'Email Address Successfully Updated'
  GROUP_UPDATED = 'Group Successfully Updated'
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
  SUPPORTING_ASSESSMENT_SAVED = 'Supporting Assessments Successfully Saved'

  def error_text
    find(ERROR_BANNER)
    return text(NOTIFICATION_BANNER)
  end

  def success_text
    find(SUCCESS_BANNER)
    return text(NOTIFICATION_BANNER)
  end

end