# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_overview_page'

describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:facesheet_overview_page) { FacesheetOverviewPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_consent

      log_in_as(Login::ORG_COLUMBIA)
      expect(home_page.page_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id
      )
    }

    it 'Add Phone Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Phone Call', duration: '15m', content: Faker::Lorem.sentence(word_count: 5) }
      facesheet_overview_page.add_interaction(interaction_note)
      created_note = facesheet_overview_page.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Add Email Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Email', duration: 'N/A', content: Faker::Lorem.sentence(word_count: 5) }
      facesheet_overview_page.add_interaction(interaction_note)
      created_note = facesheet_overview_page.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end

    it 'Add In-Person Interaction Note', :uuqa_157 do
      interaction_note = { type: 'Meeting', duration: '> 2h 30m', content: Faker::Lorem.sentence(word_count: 5) }
      facesheet_overview_page.add_interaction(interaction_note)
      created_note = facesheet_overview_page.first_interaction_note_in_timeline
      expect(created_note).to eql(interaction_note)
    end
  end
end
