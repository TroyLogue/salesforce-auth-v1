require 'uniteus-api-client'
require 'faker'

def form_data(questions)
  data = []
  questions.map do |question|
    case question.input_type
    when 'select'
      data.push({ question_id: question.id, response_value: [question.input_options.sample.id] })
    when 'number'
      data.push({ question_id: question.id, response_value: rand(1..3) })
    when 'email'
      data.push({ question_id: question.id, response_value: Faker::Internet.email })
    when 'date'
      data.push({ question_id: question.id, response_value: (DateTime.now - 1).to_time.to_i })
    when 'duration'
      data.push({ question_id: question.id, response_value: [(DateTime.now - 2).to_time.to_i, (DateTime.now - 1).to_time.to_i] })
    else
      data.push({ question_id: question.id, response_value: Faker::Lorem.sentence })
    end
  end

  data
end

module Setup
  class Screenings
    class << self
      def create(token:, group_id:, contact_id:, form_id:, network_id:)
        form_response = Requests::Forms.get(token: token, group_id: group_id, contact_id: contact_id, form_id: form_id)
        raise("Response returned: #{form_response.status}") unless form_response.status == 200

        parsed_form_response = JSON.parse(form_response, object_class: OpenStruct).data
        all_questions = parsed_form_response.sections.map(&:questions).flatten

        payload = Payloads::Screenings::Create.new(data: form_data(all_questions), network_id: network_id)

        response = Requests::Screenings.create(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          form_id: form_id,
          payload: payload
        )

        raise("Response returned: #{response.status}") unless response.status == 201

        JSON.parse(response, object_class: OpenStruct).data
      end
    end
  end
end
