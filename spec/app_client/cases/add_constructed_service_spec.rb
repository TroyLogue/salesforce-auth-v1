# frozen_string_literal: true

require_relative '../cases/pages/case'

describe '[Payments]', :app_client, :payments do
  let(:case_detail_page) { Case.new(@driver) }

  context('[as Payments User') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::PAYMENTS_USER)
      @contact = Setup::Data.create_payments_client_with_consent

      byebug
      @case = Setup::Data.create_service_case_for_payments(contact_id: @contact.contact_id)
      case_detail_page.authenticate_and_navigate_to(token: @auth_token,
                                                    path: "/dashboard/cases/open/#{@case.id}/contact/#{@contact.contact_id}")
      expect(case_detail_page.page_displayed?).to be_truthy
    end

    it 'adds a service', :demo do
      case_detail_page.click_contracted_service_button
      expect(case_detail_page.contracted_service_form_displayed?).to be_truthy

      # date = faker value
      # cost = 2
      # case_detail_page(fill_in_contracted_services_form(date: date, cost: cost))
      # verify the output on timeline/notes after submission
    end
  end
end
