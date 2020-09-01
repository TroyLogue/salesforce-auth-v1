require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative './pages/exports'

describe '[Reports - Create Export]', :reports, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:exports) { Exports.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_exports
      expect(exports.page_displayed?).to be_truthy
    }

    it 'creates an export', :uuqa_152 do
      exports.click_new_export
      exports.fill_export_form_user
      exports.submit_export_form
      expect(exports.has_pending?).to be_truthy
    end
  end
end
