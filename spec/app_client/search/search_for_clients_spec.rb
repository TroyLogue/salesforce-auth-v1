# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/search_results_page'

describe '[Search]', :app_client, :search do
  let(:home_page) { HomePage.new(@driver) }
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:search_results_page) { SearchResultsPage.new(@driver) }

  context('[as org user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'Search Bar Results Table', :uuqa_170 do
      search_bar.search_for('E')
      expect(search_bar.get_search_name_list.count).to be < 13
      expect(search_bar.get_search_name_list).to all(start_with('E'))
    end

    it 'Search Page Results Table', :uuqa_663 do
      search_bar.go_to_search_results_page('E')
      expect(search_bar.are_results_not_displayed?).to be_truthy
      expect(search_results_page.get_search_name_list).to all(include('E'))
    end
  end
end
