require_relative '../../../shared_components/base_page'

module OrgSettings
    class OrgTabs < BasePage
        PROFILE_TAB = { css: '#org-settings-tab'}
        PROGRAMS_TAB = { css: '#org-programs-tab' }
        USERS_TAB = { css: '#org-users-tab' }

        def go_to_profile_tab
            click(PROFILE_TAB)
        end

        def go_to_programs_tab
            click(PROGRAMS_TAB)
        end

        def go_to_users_tab
            click(USERS_TAB)
        end
    end
end
