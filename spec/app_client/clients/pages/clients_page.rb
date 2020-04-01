require_relative '../../../shared_components/base_page'

class ClientsPage < BasePage 
    
    FILTER_BAR = { css: ".filter-bar"}
    FILTER_SELECTION = { css: "button[name='%s']"}
    CLIENT_TABLE = {css: ".dashboard-inner-content"}
    CLIENT_NAME_LIST = {css: "tr[id^='all-clients-table-row'] > td:nth-child(2) > span" }

    def page_displayed?
        is_displayed?(FILTER_BAR)
        wait_for_spinner
    end

    def click_filter_lastname_letter(letter)
        click(FILTER_SELECTION.transform_values{|v| v % letter})
        wait_for_spinner
    end

    def get_client_name_list
        names = find_elements(CLIENT_NAME_LIST)
        names_array = names.collect(&:text)
    end 
end  
