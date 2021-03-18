require_relative '../root/pages/home_page'
require_relative '../facesheet/pages/facesheet_profile_page'
require_relative '../facesheet/pages/facesheet_header'

describe '[Messaging - Email Notifications]', :app_client, :messaging do
  include Login
  include MailtrapHelper

  let(:home_page) { HomePage.new(@driver) }

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
      # Verify email body does not contain service type name
      expect(body(message)).not_to include('Drug/Alcohol Testing');
    end

  end
end
