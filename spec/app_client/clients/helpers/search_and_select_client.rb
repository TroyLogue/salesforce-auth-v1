require_relative '../../../spec_helper'
require_relative '../pages/search_client_page'
require_relative '../pages/confirm_client_page'
require_relative '../pages/add_client_page'

module Client
  @search_page = SearchClient.new(@driver)
  @confirm_page = ConfirmClient.new(@driver)

  def search_and_select_first(fname:, lname:, dob:)
    expect(@search_page.page_displayed?).to be_truthy
    @search_page.search_client(fname: fname, lname: lname, dob: dob)
    expect(@confirm_page.page_displayed?).to be_truthy
    @confirm_page.select_nth_client(index: 0)
  end
end
