# frozen_string_literal: true

RSpec.describe 'When Auth receives a signed request, validate the username and base/launch URL against the user records in the Auth database.' do

  context 'Parameters validation - successful parameters validation.' do
    it 'Receives a signed request from Salesforce.'
    it 'Captures the "Username", "base/launch" URL.'
    it 'Compares the "Username" and "base/launch" URL with the users record in the Auth database.'

    it 'Logs the user in if the record matches.'
  end

  context 'Parameters validation - wrong "username".' do
    it 'Receives a signed request from Salesforce.'
    it 'Captures the "Username", "base/launch" URL.'
    it 'Compares the "Username" and "base/launch" URL with the users record in the Auth database.'
    it 'Returns a "login" error if the record does not match.'
    it 'Logs the user in if the record matches.'
  end

  context 'Parameters validation - invalid/inactive base URL.' do
    it 'Receives a signed request from Salesforce.'
    it 'Captures the "Username", "base/launch" URL.'
    it 'Compares the "Username" and "base/launch" URL with the users record in the Auth database.'
    it 'Returns a "login" error if the record does not match.'
    it 'Logs the user in if the record matches.'
  end

  context 'Parameters validation - no user in the Auth database' do
    it 'Receives a signed request from Salesforce.'
    it 'Captures the "Username", "base/launch" URL.'
    it 'Compares the "Username" and "base/launch" URL with the users record in the Auth database.'
    it 'Returns a "login" error if the record does not match.'
    it 'Logs the user in if the record matches.'
  end
end