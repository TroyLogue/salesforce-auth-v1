require_relative '../../../shared_components/base_page'

class Facesheet < BasePage 
    NAME_HEADER = { css: '.status-select__full-name.display' }
    OVERVIEW_TAB = { css: '#facesheet-overview-tab' }
    PROFILE_TAB = { css: '#facesheet-profile-tab'} 
    CASES_TAB = { css: '#facesheet-cases-tab' }
    FORMS_TAB = { css: '#facesheet-forms-tab' }
    UPLOADS_TAB = { css: '#facesheet-uploads-tab' }
    REFERALS_TAB = { css: '#facesheet-referrals-tab' }

    def page_displayed?
        is_displayed?(FILTER_BAR)
        wait_for_spinner
    end

    def get_facesheet_name
        text(NAME_HEADER)
    end

    def go_to_uploads
        click(UPLOADS_TAB)
        wait_for_spinner
    end
    
    def go_to_overview
        click(OVERVIEW_TAB)
        wait_for_spinner
    end

    def go_to_facesheet_with_contact_id(id:, tab: '')
        get("/facesheet/#{id}/#{tab}")
    end

end
