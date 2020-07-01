require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../assistance_request/widget_page/widget_page'
require 'Faker'



describe '[Assistance Request]', :ehr, :clients do
    let(:base_page) { BasePage.new(@driver) }
    let(:widget_page) { WidgetPage.new(@driver) }

    it 'creates an assistance request', :uuqa_689 do
        widget_page.get_widget_page
        expect(widget_page.widget_page_displayed?).to be_truthy
        widget_page.submit_form_with_all_fields(
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            middle_initial: Faker::Name.initials(number: 1),
            dob: '01/01/1990',
            email: Faker::Internet.email,
            ssn: Faker::Number.number(digits: 9),
            description: Faker::Lorem.paragraph(sentence_count: 5),
            address_1: Faker::Address.street_address,
            address_2: Faker::Address.secondary_address,
            city: Faker::Address.city,
            zip: Faker::Address.zip_code
        )
        expect(widget_page.widget_page_displayed?).to be_truthy
        expect(widget_page.success_page_displayed?).to be_truthy
        expect(widget_page.success_message).to eq(WidgetPage::SUCCESS_MESSAGE)
        expect(widget_page.success_link_message).to eq(WidgetPage::DOWNLOAD_MESSAGE)
        expect(widget_page.success_pdf).to include(WidgetPage::PDF_TEXT)
    end   
end