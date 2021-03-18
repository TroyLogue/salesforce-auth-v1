describe '[Messaging - Email Notifications]', :app_client, :messaging do
  include Login
  include MailtrapHelper

  context('[as an org user]') do
    before {
      # Create contact with email notifications enabled
      @contact = Setup::Data.create_harvard_client_with_consent
      Setup::Data.enable_email_notifications_for_contact(contact: @contact)

      # Create sensitive referral and send to Princeton
      @sensitive_referral = Setup::Data.send_sensitive_referral_from_harvard_to_princeton(contact_id: @contact.contact_id);

      # Accept the referral in Princeton
      Setup::Data.accept_referral_in_princeton
    }

    it 'receives an email when a sensitive referral is accepted', :uuqa_1467 do
      # Check mailtrap
      message = get_first_message(filter: '[STAGING] Your referral has been accepted')
      # Verify email body contains correct text
      expect(body(message)).to include('Your referral has been accepted and you should expect to be contacted.');
      # Verify email body does not contain service type name
      expect(body(message)).not_to include('Drug/Alcohol Testing')
    end
  end

  context('[as an org user] Non-sensitive referral') do
    before {
      # Create contact with email notifications enabled
      @contact = Setup::Data.create_harvard_client_with_consent
      Setup::Data.enable_email_notifications_for_contact(contact: @contact)

      # Create sensitive referral and send to Princeton
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id);

      # Accept the referral in Princeton
      Setup::Data.accept_referral_in_princeton
    }

    it 'receives an email when a non-sensitive referral is accepted', :uuqa_1467 do
      message = get_first_message(filter: '[STAGING] Your Disability Benefits referral has been accepted')
      expect(body(message)).to include('Your Disability Benefits referral has been accepted and you should expect to be contacted.')
    end
  end
end
