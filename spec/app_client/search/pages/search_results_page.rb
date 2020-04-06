require_relative '../../../shared_components/base_page'

class SearchResultsPage < BasePage 
    
    SEARCH_TABLE = { css: ".ui-base-card.ui-base-card--bordered.search" }
    SEARCH_NAME = { xpath: "//tr[contains(@id,'contact-row')]/td[contains(text(), '%s')]"}
    SEARCH_NAME_LIST = { css: "td[id^='contact-full_name']" }

    def page_displayed?
        is_displayed?(SEARCH_TABLE)
        wait_for_spinner
    end

    def go_to_facesheet_of(name)
        click(SEARCH_NAME.transform_values{|v| v % name})
        wait_for_spinner
    end

    def get_search_name_list
        names = find_elements(SEARCH_NAME_LIST)
        names_array = names.collect(&:text)
    end 
end  
