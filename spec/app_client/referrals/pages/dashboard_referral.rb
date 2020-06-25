require_relative '../../../../lib/file_helper'

class Referral < BasePage
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }
  MILITARY_ASSESSMENT = { css: '#military-information-link' }

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

  TAKE_ACTION_BUTTON = { css: '.action-select-container' }

  def go_to_new_referral_with_id(referral_id:)
    get("/dashboard/new/referrals/#{referral_id}")
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

  def assessment_list
    text(ASSESSMENT_LIST)
  end

  def document_list
    text(DOCUMENT_LIST)
  end

  def no_documents?
    is_displayed?(DOCUMENT_EMPTY_LIST)
  end

  def open_assessment(assessment_name:)
    click(ASSESSMENT_LINK.transform_values { |v| v % assessment_name })
  end

  def remove_document_from_referral(file_name:)
    hover_over(DOCUMENT_LINK.transform_values { |v| v % file_name })
    click(DOCUMENT_REMOVE.transform_values { |v| v % file_name })
    is_displayed?(DOCUMENT_REMOVE_MODAL)
    click(DOCUMENT_REMOVE_BTN)
  end

  def take_action_button_is_displayed?
    is_displayed?(TAKE_ACTION_BUTTON)
  end

end
