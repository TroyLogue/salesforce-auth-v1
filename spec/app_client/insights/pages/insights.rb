# frozen_string_literal: true
require_relative '../../../shared_components/base_page'

class Insights < BasePage
  DOWNLOAD_BUTTON = { css: 'button.tableau-download-form__submit' }.freeze
  SELECT_VIEW = { css: 'div.ui-select-field:nth-child(1)' }.freeze
  SELECT_VIEW_FIRST_OPTION = { css: '#choices-tableau-view-item-choice-2' }.freeze
  DOWNLOAD_TYPE = { css: 'div.ui-select-field:nth-child(2)' }.freeze
  DOWNLOAD_TYPE_CSV = { css: '#choices-tableau-download-type-item-choice-4' }.freeze
  DOWNLOAD_TYPE_IMAGE = { css: '#choices-tableau-download-type-item-choice-3' }.freeze
  DOWNLOAD_TYPE_PDF = { css: '#choices-tableau-download-type-item-choice-2' }.freeze
  DOWNLOAD_COUNT = { css: 'span.insights__download-length' }.freeze
  FIRST_FILE_DOWNLOAD_TABLE = { css: 'table > tbody > tr:nth-child(1) > td:nth-child(1)' }.freeze
  FIRST_DOWNLOAD_LINK = { css: 'tr:nth-child(1) > td:nth-child(3)' }

  def page_displayed?
    is_displayed?(SELECT_VIEW) &&
      is_displayed?(DOWNLOAD_TYPE)
    is_displayed?(DOWNLOAD_BUTTON) &&
      is_displayed?(DOWNLOAD_COUNT)
  end

  def current_download_count
    is_displayed?(DOWNLOAD_COUNT)
    text(DOWNLOAD_COUNT).scan(/\d/).join('').to_i
  end

  def tableau_iframe_exists?
    is_displayed?(SELECT_VIEW) &&
      is_displayed?(DOWNLOAD_TYPE)
    iframe_title == "data visualization"
  end

  def click_download
    click(DOWNLOAD_BUTTON)
    wait_for_download_spinner
    is_displayed?(DOWNLOAD_BUTTON)
  end

  def click_first_download_link
    is_displayed?(FIRST_DOWNLOAD_LINK)
    scroll_to(FIRST_DOWNLOAD_LINK)
    click(FIRST_DOWNLOAD_LINK)
  end

  def select_activity_first_option
    click(SELECT_VIEW)
    click(SELECT_VIEW_FIRST_OPTION)
  end

  def select_file_type_csv
    click(DOWNLOAD_TYPE)
    click(DOWNLOAD_TYPE_CSV)
  end

  def select_file_type_image
    click(DOWNLOAD_TYPE)
    click(DOWNLOAD_TYPE_IMAGE)
  end

  def select_file_type_pdf
    click(DOWNLOAD_TYPE)
    click(DOWNLOAD_TYPE_PDF)
  end

  def first_file_contains(extension)
    text(FIRST_FILE_DOWNLOAD_TABLE).include? extension
  end

end