require_relative '../../../shared_components/base_page'

class HomePage < BasePage
  NAVBAR = { css: '.navigation' }

  def page_displayed?
    is_displayed?(NAVBAR)
  end
end
