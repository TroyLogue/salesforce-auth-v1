# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/notes'
require_relative '../root/pages/notifications'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_overview_page'

describe '[Facesheet]', :app_client, :facesheet do
  let(:facesheet_overview) { FacesheetOverview.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:notes) { Notes.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }

  context('[as a Supervisor] On a clients facesheet') do
    before(:context) {
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_consent
    }

    before {
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
    }

    it 'Adds a Phone Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Phone Call', duration: '15m', content: Faker::Lorem.sentence(word_count: 5) }
      notes.add_interaction(interaction_note)
      expect(notifications.success_text).to eq(Notifications::NOTE_ADDED)

      created_note = facesheet_overview.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Adds a Email Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Email', duration: 'N/A', content: Faker::Lorem.sentence(word_count: 5) }
      notes.add_interaction(interaction_note)
      expect(notifications.success_text).to eq(Notifications::NOTE_ADDED)

      created_note = facesheet_overview.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Adds a In-Person Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Meeting', duration: '> 2h 30m', content: Faker::Lorem.sentence(word_count: 5) }
      notes.add_interaction(interaction_note)
      expect(notifications.success_text).to eq(Notifications::NOTE_ADDED)

      created_note = facesheet_overview.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end
  end

  context('[as a Referral Admin user]') do
    context('[client with an open case]') do
      before{
        # Create contact with an open case
        @contact = Setup::Data.create_yale_client_with_consent
        @case = Setup::Data.create_service_case_for_yale(contact_id: @contact.contact_id)

        auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
        home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
        expect(home_page.page_displayed?).to be_truthy
        facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      }

      it 'add notes to clients case', :uuqa_1592, :uuqa_1595, :uuqa_1597 do
        aggregate_failures 'option to add a note to a case is available' do
          notes.click_type_of_note(type: 'Interaction')
          expect(notes.add_note_to_case_displayed?).to be_truthy

          # Service tab only displays on clients with open cases
          notes.click_type_of_note(type: 'Service')
          expect(notes.add_note_to_case_displayed?).to be_truthy

          notes.click_type_of_note(type: 'Other')
          expect(notes.add_note_to_case_displayed?).to be_truthy
        end
      end
    end

    context('[client with enabled notifications]') do
      let(:email_address) { Faker::Internet.email }
      before {
        # Create Contact with notifications enabled for an email
        @contact = Setup::Data.create_yale_client_with_consent
        @contact.add_email_address(email_address: email_address, notifications: true)

        auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
        home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
        expect(home_page.page_displayed?).to be_truthy
        facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      }
      it 'Message a client', :uuqa_1596 do
        notes.send_message_to_client(method: email_address, note: Faker::Lorem.sentence(word_count: 5))
        expect(notifications.success_text).to eq(Notifications::MESSAGE_SENT)
      end
    end
  end
end
