require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative './pages/exports'

describe '[Reports - Create Export]', :reports, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:exports) { Exports.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_exports
      expect(exports.page_displayed?).to be_truthy
    }

    context('with network export source,') do
      it 'creates an export', :uuqa_152 do
        exports.click_new_export
        exports.fill_export_form_cc_user(source: Exports::NETWORK)
        exports.submit_export_form
        expect(notifications.success_text).to eq(Notifications::EXPORT_CREATED)
        expect(exports.has_pending?).to be_truthy
      end
    end

    context('with organization export source,') do
      it 'creates an export', :uuqa_152 do
        exports.click_new_export
        exports.fill_export_form_cc_user(source: Exports::ORGANIZATION)
        exports.submit_export_form
        expect(notifications.success_text).to eq(Notifications::EXPORT_CREATED)
        expect(exports.has_pending?).to be_truthy
      end
    end
  end

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_exports
      expect(exports.page_displayed?).to be_truthy
    }
    # With the resolution of UU3-47689, test case can be updated to match requirements in UU3-52079
    it 'creates an export', :uuqa_152 do
      exports.click_new_export
      exports.fill_export_form_org_user
      exports.submit_export_form
      expect(notifications.success_text).to eq(Notifications::EXPORT_CREATED)
      expect(exports.has_pending?).to be_truthy
    end
  end
end
