# frozen_string_literal: true

require_relative '../cases/pages/case'

describe '[Payments]', :app_client, :payments do
  let(:case_detail_page) { Case.new(@driver) }

  context('[as Payments User]') do
    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PAYMENTS_USER)
      contact = Setup::Data.create_payments_client_with_consent
      kase = Setup::Data.create_service_case_for_payments(contact_id: contact.contact_id)
      case_detail_page.authenticate_and_navigate_to(token: auth_token,
                                                    path: "/dashboard/cases/open/#{kase.id}/contact/#{contact.contact_id}")

      expect(case_detail_page.page_displayed?).to be_truthy
    end

    it 'adds a service', :pays_826 do
      starts_at = Faker::Date.between(from: Date.today, to: Date.today).strftime('%m/%d/%Y')
      unit_amount = Faker::Number.number(digits: 2)
      contracted_service_form_values = {
        unit_amount: unit_amount,
        starts_at: starts_at,
      }

      case_detail_page.click_contracted_service_button
      expect(case_detail_page.contracted_service_form_displayed?).to be_truthy

      case_detail_page.submit_contracted_services_form(contracted_service_form_values)
      expect(case_detail_page.detail_card_values).to eq(contracted_service_form_values)
    end
  end
end
