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
            expect(widget_page.success_message).to eq("Success !")
            expect(widget_page.success_link).to eq("Download Your Signed Consent Form")
            expect(widget_page.success_pdf).to include('pdf')
        end
    end   
end