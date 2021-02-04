require 'uniteus-api-client'
require 'faker'

module Setup
  class Referral
    class << self
      attr_accessor :id, :network, :program, :sent_org, :received_org, :service_type,
                    :worker, :closed_by, :sent_by, :reject_reason

      def create(token:, group_id:, contact_id:, **params)
        request_body = Payloads::Referrals::Create.new(
          {
            description: Faker::Lorem.sentence(word_count: 5),
            referred_by_network_id: params[:referred_by_network_id],
            referred_to_network_id: params[:referred_to_network_id],
            referred_to_groups: params[:referred_to_groups],
            service_type_id: params[:service_type_id]
          }
        )

        response = Requests::Referrals.create(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          referral: request_body
        )

        raise("Response returned: #{response.status}") unless response.status == 201

        parsed_response = JSON.parse(response, object_class: OpenStruct).data.first

        @id = parsed_response.id

        # Storing string versions of id's
        @network = parsed_response.referred_by_network.name
        @sent_org = parsed_response.referred_by_group.name
        @received_org = parsed_response.referred_to_group.name
        @service_type = parsed_response.service_type.name
        @sent_by = parsed_response.created_by.full_name

        self
      end

      def draft(token:, group_id:, contact_id:, **params)
        request_body = Payloads::Referrals::Create.new(
          {
            description: Faker::Lorem.sentence(word_count: 5),
            referred_by_network_id: params[:referred_by_network_id],
            referred_to_network_id: params[:referred_to_network_id],
            referred_to_groups: params[:referred_to_groups],
            service_type_id: params[:service_type_id]
          }
        )
        response = Requests::Referrals.draft(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          referral: request_body
        )

        raise("Response returned: #{response.status}") unless response.status == 201

        parsed_response = JSON.parse(response, object_class: OpenStruct).data.first

        @id = parsed_response.id

        # Storing string versions of id's
        @network = parsed_response.referred_by_network.name
        @sent_org = parsed_response.referred_by_group.name
        @received_org = parsed_response.referred_to_group ? parsed_response.referred_to_group.name : ''
        @service_type = parsed_response.service_type.name
        @sent_by = parsed_response.created_by.full_name

        self
      end

      def accept(token:, group_id:, **params)
        request_body = Payloads::Referrals::Accept.new(
          {
            entry_date: Time.now.to_i,
            primary_case_worker_id: params[:primary_case_worker_id],
            program_id: params[:program_id]
          }
        )

        response = Requests::Referrals.accept(
          token: token,
          group_id: group_id,
          referral_id: @id,
          payload: request_body
        )
        raise("Response returned: #{response.status}") unless response.status == 200

        parsed_response = JSON.parse(response, object_class: OpenStruct).data

        # Storing string versions of id's
        @received_org = parsed_response.referred_to_group.name

        parsed_response
      end

      def close(token:, group_id:, **params)
        request_body = {
          note: params[:notes],
          outcome_id: params[:outcome_id],
          resolved: params[:resolved]
        }

        response = Requests::Referrals.close(
          token: token,
          group_id: group_id,
          referral_id: @id,
          closing: request_body
        )
        raise("Response returned: #{response.status}") unless response.status == 200

        parsed_response = JSON.parse(response, object_class: OpenStruct).data

        # Storing string versions of id's
        @closed_by = parsed_response.closing.created_by.full_name

        parsed_response
      end

      def recall(token:, group_id:, **params)
        request_body = Payloads::Referrals::Recall.new(
          note: params[:note],
          reason: params[:reason]
        ).to_h

        response = Requests::Referrals.recall(
          token: token,
          group_id: group_id,
          referral_id: @id,
          payload: request_body
        )
        raise("Response returned: #{response.status}") unless response.status == 200

        parsed_response = JSON.parse(response, object_class: OpenStruct).data
      end

      def reject(token:, group_id:, **params)
        request_body = Payloads::Referrals::Reject.new(
          note: params[:note],
          reason: params[:reason],
          reason_shortened: params[:reason_short]
        )

        response = Requests::Referrals.reject(
          token: token,
          group_id: group_id,
          referral_id: @id,
          payload: request_body
        )
        raise("Response returned: #{response.status}") unless response.status == 200

        parsed_response = JSON.parse(response, object_class: OpenStruct).data
        # String data
        @reject_reason = parsed_response.rejection.reason_shortened

        parsed_response
      end

      def hold(token:, group_id:, **params)
        request_body = Payloads::Referrals::Hold.new(
          note: params[:note],
          reason: params[:reason]
        )

        response = Requests::Referrals.hold(
          token: token,
          group_id: group_id,
          referral_id: @id,
          payload: request_body
        )
        raise("Response returned: #{response.status}") unless response.status == 200

        parsed_response = JSON.parse(response, object_class: OpenStruct).data
      end
    end
  end
end
