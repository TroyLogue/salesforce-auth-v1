# frozen-string-literal: true

# Payments features involving fee schedules can only be accessed via programs that are manually configured
# via Rails console https://uniteus.atlassian.net/wiki/spaces/SMSO/pages/2519957858/Linking+Programs+to+Fee+Schedule+Programs
# Toward running payments specs in training and production, we can declare program names per environment

module ProgramNames
  PROGRAM_WITH_FEE_SCHEDULE = 'Reimbursement for Health-Related Private Transportation'
end
