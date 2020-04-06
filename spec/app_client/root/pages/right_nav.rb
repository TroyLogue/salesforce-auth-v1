require_relative '../../../shared_components/base_page'

module RightNav

    class SearchBar < BasePage
        SEARCH_ICON = { css: '#right-nav-search-btn'}
        SEARCH_INPUT  = { css: '.search-bar__input'}
        SEARCH_RESULT_TABLE = { css: ".search-results-section"}
        SEARCH_RESULT_CLIENT_NAME = { xpath: "//tr[contains(@id,'contact')]/td[contains(text(), '%s')]" }
        SEARCH_RESULT_CLIENT_NAME_LIST = { css: ".search-result > td:nth-child(1)"}
        
        def search_for(name)
            click(SEARCH_ICON)
            enter(name, SEARCH_INPUT)        
            wait_for_spinner
        end

        def go_to_search_table(name)
            click(SEARCH_ICON)
            enter(name, SEARCH_INPUT)        
            find(SEARCH_INPUT).send_keys :enter
            wait_for_spinner
        end
        
        def go_to_facesheet_of(name)
            click(SEARCH_RESULT_CLIENT_NAME.transform_values{|v| v % name})
            wait_for_spinner
        end

        def get_search_name_list
            names = find_elements(SEARCH_RESULT_CLIENT_NAME_LIST)
            names_array = names.collect(&:text)
        end 

        def are_results_not_displayed?
            is_not_displayed?(SEARCH_RESULT_TABLE, 3)
        end
    end
end
