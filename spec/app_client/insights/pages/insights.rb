# frozen_string_literal: true
require_relative '../../../shared_components/base_page'

class Insights < BasePage
  INSIGHT_ANALYTICS_PAGE = { css: '#insights' }.freeze
  DOWNLOAD_BUTTON = { css: 'button.tableau-download-form__submit' }.freeze
  SELECT_VIEW = { css: 'div.ui-select-field:nth-child(1)' }.freeze
  SELECT_VIEW_FIRST_OPTION = { css: '#choices-tableau-view-item-choice-2' }.freeze
  TABLE_VIEW_DOWNLOAD_FORM = { css: '#tableau-download-form' }.freeze
  DOWNLOAD_TYPE = { css: 'div.ui-select-field:nth-child(2)' }.freeze
  DOWNLOAD_TYPE_CSV = { css: '#choices-tableau-download-type-item-choice-4' }.freeze
  DOWNLOAD_TYPE_IMAGE = { css: '#choices-tableau-download-type-item-choice-3' }.freeze
  DOWNLOAD_TYPE_PDF = { css: '#choices-tableau-download-type-item-choice-2' }.freeze
  DOWNLOAD_COUNT = { css: 'span.insights__download-length' }.freeze
  TABLEAU_IFRAME = { css: '#tableau-viz > iframe' }.freeze
  FIRST_FILE_DOWNLOAD_TABLE = { css: 'table > tbody > tr:nth-child(1) > td:nth-child(1)' }.freeze
  FIRST_DOWNLOAD_LINK = { css: 'tr:nth-child(1) > td:nth-child(3)' }

  def get_current_download_count
    text(DOWNLOAD_COUNT).scan(/\d/).join('').to_i
  end

  def get_download_count_after
    text(DOWNLOAD_COUNT).scan(/\d/).join('').to_i
  end

  def table_view_download_form_displayed?
    is_displayed?(TABLE_VIEW_DOWNLOAD_FORM)
  end

  def tableau_iframe_exists?
    get_iframe_title == "data visualization"
  end

  def click_download
    click(DOWNLOAD_BUTTON)
    # it takes time to download
    sleep_for(5)
  end

  def insight_center_displayed?
    is_displayed?(INSIGHT_ANALYTICS_PAGE) &&
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
