require_relative '../../../shared_components/base_page'

class FaceSheet < BasePage 
    
    NAME_HEADER = { css: '.status-select__full-name.display'}

    def page_displayed?
        is_displayed?(FILTER_BAR)
        wait_for_spinner
    end

    def get_facesheet_name
        text(NAME_HEADER)
    end
end  
