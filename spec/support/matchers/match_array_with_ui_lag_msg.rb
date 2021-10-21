# frozen_string_literal: true

# In some specs we assert that values in the UI are updated as expected, and there is no explicit wait availble toward ensuring the value has changed.
# This matcher is designed to provide a meaningul error message should we see flakes due to known lags.
# We hope to address this pain point in the front-end rewrite:
# https://uniteus.atlassian.net/wiki/spaces/QA/pages/2278490206/Front-end+Rewrite+Historical+Testing+Challenges#lags-in-updating-values-on-the-UI
RSpec::Matchers.define :match_array_with_ui_lag_msg do |expected_values|
  match do |actual_values|
    expect(actual_values).to match_array(expected_values)
  end
  failure_message do |actual_values|
    "E2E ERROR: got #{actual_values}, expected #{expected_values} : UI lags can cause flakes; if common, add page refresh before asserting"
  end
end
