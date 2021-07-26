# frozen_string_literal: true

module Networks
  case ENV['ENVIRONMENT']
  when 'prod'
    GENERAL_P2P_NETWORK = '43a19ee5-653d-4efe-989e-a219c7665bdb' # End to End Tests - General P2P - [Technology Team Only][DO NOT USE]
  when 'training'
    GENERAL_P2P_NETWORK = '6355ea84-680f-4cc9-b6ed-310af11ca42d' # End to End Tests - General P2P - [Technology Team Only][DO NOT USE]
  when 'staging', 'devqa'
    GENERAL_P2P_NETWORK = 'd8e7a7f0-d4f1-459b-bab4-15802b371cae' # Ivy League Network
    PAYMENTS_NETWORK = 'd14074c5-91ec-4c94-a77e-aa6035251447' # Healthy Opportunities
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
