require_relative '../widgets/pages/assistance_requests_widget'

describe '[Assistance Request Widget]', :widgets, :assistance_request do
  let(:widget_page) { AssistanceRequestWidget.new(@driver) }

  before{
    @fname = Faker::Name.first_name
    @lname = Faker::Name.last_name
    @dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
    @description = Faker::Lorem.paragraph(sentence_count: 1)
    @minitial = Faker::Name.initials(number: 1)
    @phone = Faker::Number.number(digits: 10)
    @email = Faker::Internet.email
    @address1 = Faker::Address.street_address
    @address2 = Faker::Address.secondary_address
    @city = Faker::Address.city
    @zip = Faker::Address.zip_code
    @income = Faker::Number.number(digits: 5)
  }

  it 'submits an assistance request with configured fields', :uuqa_1600 do
    widget_page.get_widget_page
    expect(widget_page.widget_page_displayed?).to be_truthy

    widget_page.fill_default_form_fields(first_name: @fname, last_name: @lname, dob: @dob, description: @description)
    widget_page.fill_configured_form_fields(
      middle_initial: @minitial,
      phone: @phone,
      email: @email,
      address_1: @address1,
      address_2: @address2,
      city: @city,
      zip: @zip,
      income: @income
    )
    widget_page.submit_form

    expect(widget_page.success_page_displayed?).to be_truthy
    expect(widget_page.success_message).to eq(AssistanceRequestWidget::SUCCESS_MESSAGE)
    expect(widget_page.success_link_message).to eq(AssistanceRequestWidget::DOWNLOAD_MESSAGE)
    expect(widget_page.success_pdf).to include(AssistanceRequestWidget::PDF_TEXT)
  end

  it 'submits an assistance request with custom form fields', :uuqa_689 do
    school_name = 'NYU'
    school_location = 'NYC'

    widget_page.get_widget_page
    expect(widget_page.widget_page_displayed?).to be_truthy

    widget_page.fill_default_form_fields(first_name: @fname, last_name: @lname, dob: @dob, description: @description)
    widget_page.fill_configured_form_fields(
      middle_initial: @minitial,
      phone: @phone,
      email: @email,
      address_1: @address1,
      address_2: @address2,
      city: @city,
      zip: @zip,
      income: @income
    )
    widget_page.fill_custom_form_fields(school_name: school_name, school_location: school_location)
    widget_page.submit_form

    expect(widget_page.success_page_displayed?).to be_truthy
    expect(widget_page.success_message).to eq(AssistanceRequestWidget::SUCCESS_MESSAGE)
    expect(widget_page.success_link_message).to eq(AssistanceRequestWidget::DOWNLOAD_MESSAGE)
    expect(widget_page.success_pdf).to include(AssistanceRequestWidget::PDF_TEXT)
  end

  it 'submits an assistance request with only default fields', :uuqa_1601 do
    widget_page.get_default_widget_page
    expect(widget_page.widget_page_displayed?).to be_truthy

    widget_page.fill_default_form_fields(first_name: @fname, last_name: @lname, dob: @dob, description: @description)
    widget_page.submit_form

    expect(widget_page.success_page_displayed?).to be_truthy
    expect(widget_page.success_message).to eq(AssistanceRequestWidget::SUCCESS_MESSAGE)
    expect(widget_page.success_link_message).to eq(AssistanceRequestWidget::DOWNLOAD_MESSAGE)
    expect(widget_page.success_pdf).to include(AssistanceRequestWidget::PDF_TEXT)
  end
end
