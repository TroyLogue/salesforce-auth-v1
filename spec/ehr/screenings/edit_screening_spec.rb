# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/screening'

describe '[Screenings]', :ehr, :screenings do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:screening) { Screening.new(@driver) }

  context('[default view] as a user with the Screening role') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::SCREENINGS_USER)
      expect(homepage.default_view_displayed?).to be_truthy
    end

    it 'edits and saves a screening', :uuqa_593 do
      # find or create an existing screening and go to it
      homepage.get_screening_detail(
        contact_id: Contacts::TIMMY_SMART,
        screening_id: 'c237dd14-7166-4883-91e8-92083d07bc45'
      )
      expect(screening.page_displayed?).to be_truthy
    end
  end
end
