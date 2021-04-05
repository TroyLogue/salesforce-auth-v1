# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications_ehr'
require_relative './pages/screening'

describe '[Screenings]', :ehr, :screenings do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }
  let(:screening) { Screening.new(@driver) }

  context('[default view] as a user with the Screening role') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      # data setup:
      @contact_id = homepage.contact_id
      @screening = Setup::Data.create_screening_for_harvard_contact(
        contact_id: @contact_id
      )
    end

    it 'edits and saves a screening', :uuqa_593 do
      homepage.get_screening_detail(
        contact_id: @contact_id,
        screening_id: @screening.id
      )
      expect(screening.page_displayed?).to be_truthy
      screening.click_edit
      expect(screening.edit_view_displayed?).to be_truthy
      screening.click_submit
      expect(screening.page_displayed?).to be_truthy
      expect(notifications.error_notification_not_displayed?).to be_truthy
    end
  end
end
