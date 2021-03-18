# TODO - after https://uniteus.atlassian.net/browse/UU3-24585 is implemented
# calls to mailtrap can be removed, and this can be reduced to one spec
# which should live in the api-integrations-tests repo
describe '[Messaging - Email Notifications]', :app_client, :messaging do
  include Login
  include MailtrapHelper

  context('[as an org user] When I accept a referral for a Sensitive service type') do
    before {
      # Create contact with email notifications enabled
      @contact = Setup::Data.create_harvard_client_with_consent
      Setup::Data.enable_email_notifications_for_contact(contact: @contact)

      # Create sensitive referral and accept in Princeton
      @sensitive_referral = Setup::Data.send_sensitive_referral_from_harvard_to_princeton(contact_id: @contact.contact_id);
      Setup::Data.accept_referral_in_princeton
    }

    it 'client receives an email that does not include the service type name', :uuqa_1467 do
      # Check mailtrap
      message = get_first_message(filter: '[STAGING] Your referral has been accepted')
      # Verify email body contains correct text
      expect(body(message)).to include('Your referral has been accepted and you should expect to be contacted.');
      # Verify email body does not contain service type name
      expect(body(message)).not_to include('Drug/Alcohol Testing')
    end
  end

  context('[as an org user] When I accept a referral for a Non-sensitive service type') do
    before {
      # Create contact with email notifications enabled
      @contact = Setup::Data.create_harvard_client_with_consent
      Setup::Data.enable_email_notifications_for_contact(contact: @contact)

      # Create non-sensitive referral and accept in Princeton
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id);
      Setup::Data.accept_referral_in_princeton
    }

    it 'client receives an email that includes the service type name', :uuqa_1467 do
      message = get_first_message(filter: '[STAGING] Your Disability Benefits referral has been accepted')
      expect(body(message)).to include('Your Disability Benefits referral has been accepted and you should expect to be contacted.')
    end
  end
end
