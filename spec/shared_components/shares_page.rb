# frozen_string_literal: true

class SharesPage < BasePage
  MAIN_DIV = { css: '.group' }.freeze
  HEADER = { css: '.group-header' }.freeze
  MAP = { css: '.map' }.freeze
  DETAILS = { css: '.group-details' }.freeze

  TITLE = 'Unite Us Resources'

  def page_displayed?
    is_displayed?(MAIN_DIV) &&
      is_displayed?(HEADER) &&
      is_displayed?(MAP) &&
      is_displayed?(DETAILS)
  end

  def first_group_name
    text(HEADER)
  end

  def page_title
    # when page is rendered via print, the last window contains the shares page;
    # without switching the window, the print preview will block interaction with the page
    # and it's not advised to interact with print dialog due to browser and driver variations
    switch_to_last_window
    title
  end
end
