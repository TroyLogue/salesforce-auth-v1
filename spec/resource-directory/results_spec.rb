require_relative './pages/resource_directory'

describe '[Resource Directory]', :resource_directory do
  let(:base_page) { BasePage.new(@driver) }
  let(:resource_directory) { ResourceDirectory.new(@driver) }

  # pass in resource_directory as ENV['APPLICATION']
  # when you run this so it accesses the correct base url
  before {
    base_page.get ''
    expect(resource_directory.page_displayed?).to be_truthy
  }

  it 'loads results upon page load', :uuqa_1359 do
    expect(resource_directory.results_loaded?).to be_truthy
  end
end
