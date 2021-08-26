require_relative '../../../shared_components/base_page'

class Insights < BasePage
  INSIGHT_NAV = { css: '#nav-insights' }.freeze
  INSIGHT_ANALYTICS_PAGE = { css: '#insights' }.freeze
  DOWNLOAD_BUTTON = { css: 'button.tableau-download-form__submit' }.freeze
  SELECT_VIEW = { css: 'div.ui-select-field:nth-child(1)' }.freeze
  SELECT_VIEW_FIRST_OPTION = { css: '#choices-tableau-view-item-choice-2' }.freeze
  TABLE_VIEW_DOWNLOAD_FORM = { css: '#tableau-download-form' }.freeze
  DOWNLOAD_TYPE = { css: 'div.ui-select-field:nth-child(2)' }.freeze
  DOWNLOAD_TYPE_FIRST_OPTION = { css: '#choices-tableau-download-type-item-choice-4' }.freeze
  DOWNLOAD_COUNT = { css: 'span.insights__download-length' }.freeze

  def Insight_nav_displayed?
    is_displayed?(INSIGHT_NAV)
  end

  def get_current_download_count
    @download_count_before = text(DOWNLOAD_COUNT).scan(/\d/).join('').to_i
  end

  def get_download_count_after
    @download_count_after = text(DOWNLOAD_COUNT).scan(/\d/).join('')
  end

  def download_success?
    @download_count_after.to_i > @download_count_before.to_i
  end

  def table_view_download_form_displayed?
    is_displayed?(TABLE_VIEW_DOWNLOAD_FORM)
    puts "worked ---- debug"
  end

  def click_download
    click(DOWNLOAD_BUTTON)
    # it takes time to download
    sleep 5
  end

  def insight_center_displayed?
    is_displayed?(INSIGHT_ANALYTICS_PAGE) &&
      is_displayed?(DOWNLOAD_BUTTON)
  end

  def click_insight_nav
    click(INSIGHT_NAV)
  end

  def select_activity_first_option
    click(SELECT_VIEW)
    click(SELECT_VIEW_FIRST_OPTION)
  end

  def select_file_type_first_option
    click(DOWNLOAD_TYPE)
    click(DOWNLOAD_TYPE_FIRST_OPTION)
  end

end
