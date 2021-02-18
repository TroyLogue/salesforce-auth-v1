# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class DashboardNav < BasePage
  DASHBOARD_NAV = { class: 'dashboard-nav' }
  SCREENINGS_ALL = { id: 'dashboard-screenings-all' }

  def go_to_screenings
    click(SCREENINGS_ALL)
  end

  def screenings_displayed?
    is_displayed?(SCREENINGS_ALL)
  end
end