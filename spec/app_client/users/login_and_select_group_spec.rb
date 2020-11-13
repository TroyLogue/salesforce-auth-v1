# frozen_string_literal: true

require_relative './pages/group_selector_page'
require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'

describe '[Users - ]', :app_client, :users do
  include Login

  let(:group_selector_page) { GroupSelectorPage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }

  it 'Logs in as a user who is a subscribed employee of multiple providers', :uuqa_1607 do
    log_in_as(Login::USER_IN_MULTIPLE_PROVIDERS)
    expect(group_selector_page.page_displayed?).to be_truthy
    expect(group_selector_page.number_of_provider_buttons).to be > 1

    group_selector_page.select_first_provider
    expect(home_page.page_displayed?).to be_truthy
  end
end
