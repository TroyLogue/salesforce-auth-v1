require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../assistance_request/widget_page/widget_page'



describe 'widget' do
    let(:base_page) { BasePage.new(@driver) }
    let(:widget_page) { WidgetPage.new(@driver) }
    
    CONTAINER = { css: '#container' }
    HEADER = { css: 'h3' }
    LINK = { css: 'a'}

    context 'widget' do
        it 'visit widget page' do
            widget_page.get_widget_page
            widget_page.fill_in_form
            expect(widget_page.success_page_displayed?).to be_truthy
            expect(base_page.find_within(CONTAINER, HEADER).text).to eq("Success !")
            expect(base_page.find_within(CONTAINER, LINK).text).to eq("Download Your Signed Consent Form")
        end
    end   
end