require_relative '../../../shared_components/base_page'

module RightNav
  class SearchBar < BasePage
    SEARCH_ICON = { css: '#right-nav-search-btn' }
    SEARCH_INPUT = { css: '.search-bar__input' }
    SEARCH_RESULT_TABLE = { css: '.search-results-section' }
    SEARCH_RESULT_CLIENT_NAME = { xpath: '//tr[contains(@id,"contact")]/td[contains(text(), "%s")]' }
    SEARCH_RESULT_CLIENT_NAME_LIST = { css: '.search-result > td:nth-child(1)' }

    def search_for(name)
      click(SEARCH_ICON)
      enter(name, SEARCH_INPUT)
      wait_for_spinner
    end

    def go_to_search_results_page(name)
      click(SEARCH_ICON)
      enter(name, SEARCH_INPUT)
      find(SEARCH_INPUT).send_keys :enter
      wait_for_spinner
    end

    def go_to_facesheet_of(name)
      click(SEARCH_RESULT_CLIENT_NAME.transform_values { |v| v % name })
      wait_for_spinner
    end

    def get_search_name_list
      names = find_elements(SEARCH_RESULT_CLIENT_NAME_LIST)
      names.collect(&:text)
    end

    def are_results_not_displayed?
      is_not_displayed?(SEARCH_RESULT_TABLE, 3)
    end
  end

  class CreateMenu < BasePage
    PLUS_ICON = { css: '#right-nav-create-menu-btn' }
    NEW_REFERRAL_BTN = { css: '#right-nav-create-referral-btn' }
    NEW_CLIENT_BTN = { css: '#right-nav-create-client-btn' }
    NEW_INTAKE_BTN = { css: '#right-nav-create-intake-btn' }
    NEW_SCREENING_BTN = { css: '#right-nav-create-screening-btn' }

    def start_new_referral
      click(PLUS_ICON)
      click(NEW_REFERRAL_BTN)
    end

    def start_new_client
      click(PLUS_ICON)
      click(NEW_CLIENT_BTN)
    end

    def start_new_intake
      click(PLUS_ICON)
      click(NEW_INTAKE_BTN)
    end

    def start_new_screening
      click(PLUS_ICON)
      click(NEW_SCREENING_BTN)
    end
  end

  class UserMenu < BasePage
    USER_MENU = { css: '#right-nav-user-menu-btn' }
    USER_SETTINGS_BTN = { css: '#right-nav-user-settings-btn' }
    LOG_OUT_BTN = { css: '#right-nav-user-logout-btn' }

    def go_to_user_settings
      click(USER_MENU)
      click(USER_SETTINGS_BTN)
    end

    def log_out
      click(USER_MENU)
      click(LOG_OUT_BTN)
    end
  end

  class OrgMenu < BasePage
    ORG_MENU = { css: '#right-nav-org-menu-btn' }
    USERS_BTN = { css: '#right-nav-org-users-btn' }
    PROGRAMS_BTN = { css: '#right-nav-org-programs-btn' }
    PROFILE_BTN = { css: '#right-nav-org-profile-btn' }

    def go_to_users_table
      click(ORG_MENU)
      click(USERS_BTN)
      wait_for_spinner
    end

    def go_to_programs
      click(ORG_MENU)
      click(PROGRAMS_BTN)
    end

    def go_to_profile
      click(ORG_MENU)
      click(PROFILE_BTN)
    end
  end
end
