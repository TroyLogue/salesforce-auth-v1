# frozen_string_literal: true

require_relative '../root/pages/notifications'
require_relative './pages/exports'

describe '[Reports - Create Export]', :reports, :app_client do
  let(:exports) { Exports.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      exports.authenticate_and_navigate_to(token: @auth_token, path: Exports::INDEX_PATH)
      expect(exports.page_displayed?).to be_truthy
    end

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
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_COLUMBIA)
      exports.authenticate_and_navigate_to(token: @auth_token, path: Exports::INDEX_PATH)
      expect(exports.page_displayed?).to be_truthy
    end
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
