require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative './pages/consent_modal'
require_relative './pages/pending_consent_page'

describe '[Consent - Request Consent]', :consent, :app_client do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:pending_consent_page) { PendingConsentPage.new(@driver) }

  context('[as cc user] On an incoming Pending Consent referral,') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy

      # create contact
      @contact = Setup::Data.create_yale_client

      # create referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      home_page.go_to_pending_consent
      expect(pending_consent_page.page_displayed?).to be_truthy
    }

    it 'adds consent by document upload', :uuqa_753 do
      @first_referral_text = pending_consent_page.text_of_first_referral
      @second_referral_text = pending_consent_page.text_of_second_referral
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      consent_modal.add_consent_by_document_upload

      expect(pending_consent_page.consent_modal_not_displayed?).to be_truthy

      # confirm the referral we added consent to
      # is removed from the pending consent page on refresh
      base_page.refresh
      expect(pending_consent_page.page_displayed?).to be_truthy

      @new_first_referral_text = pending_consent_page.text_of_first_referral
      expect(@new_first_referral_text).to eq(@second_referral_text)
    end

    it 'requests consent by email', :uuqa_754 do
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      address = "#{Faker::Internet.email}"
      consent_modal.request_consent_by_email(address)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CONSENT_REQUEST_SENT)
    end

    it 'requests consent by text', :uuqa_755 do
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      consent_modal.request_consent_by_text(ConsentModal::VALID_PHONE_NUMBER)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CONSENT_REQUEST_SENT)
    end
  end

  context('[as cc user] On a sent Pending Consent referral,') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy

      home_page.go_to_sent_pending_consent
      expect(pending_consent_page.page_displayed?).to be_truthy
    }

    it 'adds consent by document upload', :uuqa_758 do
      @first_referral_text = pending_consent_page.text_of_first_referral
      @second_referral_text = pending_consent_page.text_of_second_referral
      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      consent_modal.add_consent_by_document_upload

      expect(pending_consent_page.consent_modal_not_displayed?).to be_truthy

      base_page.refresh
      expect(pending_consent_page.page_displayed?).to be_truthy
      @new_first_referral_text = pending_consent_page.text_of_first_referral
      expect(@new_first_referral_text).to eq(@second_referral_text)
    end
  end

  context('[as a Referrals Admin user] On an incoming referral pending consent') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy

      # create contact
      @contact = Setup::Data.create_yale_client

      # create referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      home_page.go_to_pending_consent
      expect(pending_consent_page.page_displayed?).to be_truthy
    }

    it 'request consent text and email fields are prefilled', :uuqa_1717 do
      # Adding email to contact that will be pre-filled
      address = Faker::Internet.email
      @contact.add_email_address(email_address: address)

      # Adding phone number to contact that will be pre-filled
      phone_number = ConsentModal::VALID_PHONE_NUMBER
      @contact.add_phone_number(number: phone_number)

      # Need to refresh page so that another call is made to update values
      base_page.refresh

      pending_consent_page.open_first_consent_modal
      expect(pending_consent_page.consent_modal_displayed?).to be_truthy

      consent_modal.select_consent_by_text
      expect(consent_modal.phone_value).to eq(base_page.number_to_phone_format(phone_number))

      consent_modal.select_consent_by_email
      expect(consent_modal.email_value).to eq(address)
    end
  end
end
