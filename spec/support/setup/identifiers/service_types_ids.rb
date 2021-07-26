# frozen-string-literal: true

module Services
  case ENV['ENVIRONMENT']
  when 'prod'
    BENEFITS_BENEFITS_ELIGIBILITY_SCREENING = '21481f3c-9e92-4339-8ed1-a4028dc5fffd'
  when 'training'
    BENEFITS_BENEFITS_ELIGIBILITY_SCREENING = 'bc481389-ea72-47fd-a354-c8673eea8866'
  when 'staging', 'devqa'
    BENEFITS = '50126fcb-a3e9-45d5-9a8e-c32b7fd810b4'
    BENEFITS_BENEFITS_ELIGIBILITY_SCREENING = '2ac1bb8f-89a1-44b9-9e24-9af3cec8a2de'
    BENEFITS_DISABILITY_BENEFITS = '3e3aef24-f58d-493e-a604-8fe87019b142'
    DRUG_ALCOHOL_TESTING = 'c6a67048-36fe-4756-adbd-d7d039993131'
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
