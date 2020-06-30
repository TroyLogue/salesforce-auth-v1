require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../assistance_request/widget_page/widget_page'



describe 'Assitance request widget' do
    let(:base_page) { BasePage.new(@driver) }
    let(:widget_page) { WidgetPage.new(@driver) }
    
    context 'Client submits assistance request widget' do
        it 'completing and submitting the form for assistance request widget' do
            widget_page.get_widget_page
            widget_page.fill_in_form
            expect(widget_page.success_page_displayed?).to be_truthy
            expect(base_page.find_within(WidgetPage::CONTAINER, WidgetPage::HEADER).text).to eq("Success !")
            expect(base_page.find_within(WidgetPage::CONTAINER, WidgetPage::LINK).text).to eq("Download Your Signed Consent Form")
            expect(base_page.find_within(WidgetPage::CONTAINER, WidgetPage::LINK).attribute('href')).to include('pdf')
        end
    end   
end