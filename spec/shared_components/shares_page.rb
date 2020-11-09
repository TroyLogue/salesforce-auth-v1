# frozen_string_literal: true

class SharesPage < BasePage
  MAIN_DIV = { css: '.group' }
  HEADER = { css: '.group-header' }
  MAP = { css: '.map' }
  DETAILS = { css: '.group-details' }

  def page_displayed?
    is_displayed?(MAIN_DIV) &&
      is_displayed?(HEADER) &&
      is_displayed?(MAP) &&
      is_displayed?(DETAILS)
  end

  def first_group_name
    text(HEADER)
  end
end
