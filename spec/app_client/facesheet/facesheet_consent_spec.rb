require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative '../consent/pages/consent_modal'

describe '[Facesheet][Header]', :app_client, :facesheet do
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }

  context('[as org user]') do
    before {
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_COLUMBIA)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_columbia_client

      # Add phone number to contact
      @phone_number = Faker::Number.number(digits: 10).to_s
      @contact.add_phone_number(number: @phone_number)
    }

    it 'User can view clients consent status from facesheet header' do
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id
      )

      aggregate_failures 'options for client that needs consent' do
        expect(facesheet_header.consent_status).to eql('Needs Consent')

        facesheet_header.select_consent_option(option: facesheet_header.class::SEND_SMS)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.phone_value).to eql(consent_modal.number_to_phone_format(@phone_number))
        consent_modal.close_consent_modal

        # TO-DO, add an email to contact using api to see that this field is pre-filled
        facesheet_header.select_consent_option(option: facesheet_header.class::SEND_EMAIL)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.email_value).to eql('')
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::REQUEST_ONSCREEN)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.go_to_form_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::UPLOAD_PAPER)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.submit_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::UPLOAD_AUDIO)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.submit_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::PROVIDE_ATTESTATION)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.go_to_form_button_displayed?).to be_truthy
        consent_modal.close_consent_modal
      end

      # Requesting consent by email, using faker email for now
      @contact.request_consent_email(email: Faker::Internet.email)
      facesheet_header.refresh

      aggregate_failures 'options for client that has pending consent ' do
        expect(facesheet_header.consent_status).to eql('Pending Consent')

        facesheet_header.select_consent_option(option: facesheet_header.class::SEND_SMS)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.phone_value).to eql(consent_modal.number_to_phone_format(@phone_number))
        consent_modal.close_consent_modal

        # TO-DO, add an email to contact using api to see that this field is pre-filled
        facesheet_header.select_consent_option(option: facesheet_header.class::SEND_EMAIL)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.email_value).to eql('')
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::REQUEST_ONSCREEN)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.go_to_form_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::UPLOAD_PAPER)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.submit_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::UPLOAD_AUDIO)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.submit_button_displayed?).to be_truthy
        consent_modal.close_consent_modal

        facesheet_header.select_consent_option(option: facesheet_header.class::PROVIDE_ATTESTATION)
        expect(consent_modal.page_displayed?).to be_truthy
        expect(consent_modal.go_to_form_button_displayed?).to be_truthy
        consent_modal.close_consent_modal
      end

      # Adding consent to client
      @contact.add_consent
      facesheet_header.refresh

      aggregate_failures 'options for client that has accepted consent' do
        expect(facesheet_header.consent_status).to eql('Consent Accepted')
        facesheet_header.select_consent_option(option: facesheet_header.class::VIEW)
        expect(facesheet_header.new_tab_opened?).to be_truthy
      end
    end
  end
end
