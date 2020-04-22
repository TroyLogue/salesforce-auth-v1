module Settings

    class UserTable
        USER_TABLE = { css: '#ui-table > tr > td > a' }
        USER_TABLE_LOAD = { xpath: ".//tbody/tr/td[text()='Loading']" }
        USER_LIST  = { css: '.ui-table-body > tr > td:nth-child(1) > a' }
        USER_NAME = { xpath: ".//*[@class='ui-table-body']/tr/td/a[text()='%s']" }
        ADD_USER_BTN = { css: '#add-user-btn' }

        def page_displayed?
            wait_for_table_load
            is_displayed(USER_TABLE)
        end

        def wait_for_table_load
            is_not_displayed?(USER_TABLE_LOAD)
        end

        def get_list_of_user_names
            names = find_elements(USER_LIST)
            names_array = names.collect(&:text)
        end

        def go_to_user(name:)
            click(USER_NAME.transform_values{|v| v % name})
            wait_for_spinner
        end
        
        def go_to_new_user_form
            click(ADD_USER_BTN)
        end
    end

    class UserCard
        USER_HEADER = { css: '.ui-base-card-header__title'}

        def get_user_title
            text(USER_HEADER)
        end
    end

end
