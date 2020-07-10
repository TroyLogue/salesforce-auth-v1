require_relative '../../../../lib/file_helper'

class Referral < BasePage
  REFERRAL_STATUS = { css: '.detail-status-text.uppercase' }

  TAKE_ACTION_DROP_DOWN = { css: '.action-select-container' }
  TAKE_ACTION_OPTIONS = { css: 'div[data-value="send"]' }
  TAKE_ACTION_REJECT_OPTION = { css: 'div[data-value="reject"]'}

  SENDER_INFO = { css: '#basic-table-sender-value' }
  RECIPIENT_INFO = { css: '#basic-table-recipient-value' }

  REJECT_REFERRAL_MODAL = { css: '.reject-modal-dialog .open' }
  REJECT_REFERRAL_REASON_DROPDOWN = { css: '.referral-reject-display .referral-reason-field .choices__inner' }
  REJECT_REFERRAL_REASON_OPTION = { css: '.referral-reason-field .choices.is-open #choices-reject-reason-input-item-choice-1' }
  REJECT_REFERRAL_NOTE = { css: '#reject-note-input'}
  REJECT_BTN = { css: '.referral-reject-display__reject-modal-form #reject-referral-reject-btn'}

  DOCUMENT_ADD_LINK = { css: '#upload-document-link' }
  DOCUMENT_ATTACH_MODAL = { css: '.dialog.open.large'}
  DOCUMENT_ATTACH_BTN = { css: '#upload-submit-btn' }
  DOCUMENT_FILE_INPUT = { css: 'input[type="file"]' }
  DOCUMENT_PREVIEW = { css: '.preview-item' }
  DOCUMENT_LIST = { css: '.list-view-document__title' }
  DOCUMENT_EMPTY_LIST = { css: '.empty-documents-text' }

  DOCUMENT_LINK = { xpath: './/a[text()="%s"]'}
  DOCUMENT_REMOVE = { xpath: './/a[text()="%s"]/following-sibling::div[@class="remove-document"]' }
  DOCUMENT_REMOVE_MODAL = { css: '.dialog.open.mini'}
  DOCUMENT_REMOVE_BTN = { css: '.confirmation-dialog__actions--confirm'}

  REJECTED_STATUS = 'REJECTED'

  def go_to_new_referral_with_id(referral_id:)
    get("/dashboard/new/referrals/#{referral_id}")
    wait_for_spinner
  end

  def go_to_send_referral_with_id(referral_id:)
    get("/dashboard/referrals/sent/all/#{referral_id}")
    wait_for_spinner
  end

  def go_to_rejected_referral_with_id(referral_id:)
    get("/dashboard/referrals/rejected/#{referral_id}")
    wait_for_spinner
  end

  def current_referral_id
    uri = URI.parse(driver.current_url)
    uri.path.split('/').last
  end

  def recipient_info
    text(RECIPIENT_INFO)
  end

  def status
    text(REFERRAL_STATUS)
  end

  def send_referral_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_OPTIONS)
    wait_for_spinner
  end

  def reject_referral_action(note:)
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_REJECT_OPTION)
    is_displayed?(REJECT_REFERRAL_MODAL)
    click(REJECT_REFERRAL_REASON_DROPDOWN)
    click(REJECT_REFERRAL_REASON_OPTION)
    enter(note, REJECT_REFERRAL_NOTE)
    click(REJECT_BTN)
    wait_for_spinner
    sleep(10)
  end

  def attach_document_to_referral(file_name:)
    click(DOCUMENT_ADD_LINK)
    is_displayed?(DOCUMENT_ATTACH_MODAL)
    local_file_path = create_consent_file(file_name)
    enter(local_file_path, DOCUMENT_FILE_INPUT)
    is_displayed?(DOCUMENT_PREVIEW)
    click(DOCUMENT_ATTACH_BTN)
    #deleting local file
    delete_consent_file(file_name)
  end

  def remove_document_from_referral(file_name:)
    hover_over(DOCUMENT_LINK.transform_values { |v| v % file_name })
    click(DOCUMENT_REMOVE.transform_values { |v| v % file_name })
    is_displayed?(DOCUMENT_REMOVE_MODAL)
    click(DOCUMENT_REMOVE_BTN)
  end

  def document_list
    text(DOCUMENT_LIST)
  end

  def no_documents?
    is_displayed?(DOCUMENT_EMPTY_LIST)
  end
end
