require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative './pages/search_results_page'

describe '[Search]', :app_client, :search do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:search_results_page) { SearchResultsPage.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_YALE)
    }

    it 'Search Bar Results Table', :uuqa_170 do
      search_bar.search_for('E')
      expect(search_bar.get_search_name_list.count).to be < 13
      expect(search_bar.get_search_name_list).to all(start_with('E'))
    end

    it 'Search Page Results Table', :uuqa_663 do
      search_bar.go_to_search_results_page('E')
      expect(search_bar.are_results_not_displayed?).to be_truthy
      expect(search_results_page.get_search_name_list).to all(start_with('E'))
    end
  end
end
