require_relative '../spec_helper'
require_relative '../shared_components/base_page'
require_relative './pages/resource_directory'

describe '[Resource Directory]', :resource_directory do
  let(:base_page) { BasePage.new(@driver) }
  let(:resource_directory) { ResourceDirectory.new(@driver) }

  PROVIDER_NAME = "Agape Christian Counseling"

  before {
    base_page.get_resource_directory
    expect(resource_directory.page_displayed?).to be_truthy
  }

  it 'loads results upon page load', :uuqa_1359 do
    expect(resource_directory.find_result_by_name(PROVIDER_NAME)).to be_truthy
  end
end
