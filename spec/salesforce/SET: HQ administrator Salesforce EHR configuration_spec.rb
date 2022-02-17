# frozen_string_literal: true

RSpec.describe 'Salesforce Configuration' do

  context 'Add a new Salesforce configuration:' do
    it 'Requires the user to log into HQ2'
    it 'Requires the user to select "Salesforce" from the EMR Configurations screen dropdown.'
    it 'Requires the user to provide all required Org configuration details.'
    it 'Requires the user to save the page after all Org details have been provided.'
    it 'Applies the configuration to all the users in the Org.'
  end

  context 'Edit existing Salesforce configuration' do
    it 'Requires the user to log into HQ2'
    it 'Requires the user to select "Salesforce" from the EMR Configurations screen dropdown.'
    it 'Requires the user to select the configuration and edit Org configuration details.'
    it 'Requires the user to save the page after Org details have been edited.'
    it 'Updates the Org configuration details'
    it 'Applies the configuration to all the users in the Org.'
  end

  context 'Add invalid Salesforce configuration' do
    it 'Requires the user to log into HQ2'
    it 'Requires the user to select "Salesforce" from the EMR Configurations screen dropdown.'
    it 'Requires the user to enter invalid details or leave required Org configuration details empty.'
    it 'Requires the user to save the page after invalid Org details have been entered.'
    it 'Applies the configuration to all the users in the Org.'
    it 'Does not allow the users to access the system due to invalid Org configurations.'
  end

  context 'Add duplicate Salesforce configuration' do
    it 'Requires the user to log into HQ2'
    it 'Requires the user to select "Salesforce" from the EMR Configurations screen dropdown.'
    it 'Requires the user to enter exact same details as an existing Org configuration.'
    it 'Requires the user to save the page after Org details have been entered.'
    it '(I am not sure what is supposed to happen here.)'
  end

  context 'Delete or disable a Salesforce configuration' do
    it 'Requires the user to log into HQ2'
    it 'Requires the user to select "Salesforce" from the EMR Configurations screen dropdown.'
    it 'Requires the user to delete or disable an existing Org configuration.'
    it 'Requires the user to save the page after Org configuration details have been deleted or disabled.'
    it 'Removes the Org configuration from the EMR configuration page'
    it 'Prevents access for the users associated with the deleted/disabled Org configuration.'
  end

end
