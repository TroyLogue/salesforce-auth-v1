require_relative '../../../shared_components/base_page'

class NetworkNavigation < BasePage
  BROWSE_MAP_TAB = { css: '#browse-map-tab' }
  ORG_TAB = { css: '#org-tab' }
  USERS_TAB = { css: '#users-tab' }

  PAGE_FOOTER = { css: '.oon-group-form__footer' }

  def go_to_org_tab
    click(ORG_TAB)
  end

  def go_to_users_tab
    click(USERS_TAB)
  end
end
