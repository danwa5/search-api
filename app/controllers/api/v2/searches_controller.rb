module Api
  module V2
    class SearchesController < ApplicationController
      # POST /api/v2/search
      def create
        # A solution that's scalable to handle thousands of searches per minute is to utilize
        # SNS/SQS. The search term would be added to a SNS and then published to a topic.
        # The SNS message is available to SQS queues that are subscribed to the topic.

        # The advantages of this solution are:
        # 1. Decoupling: a decoupling of the API and the app that's receiving the message
        # 2. Fan-out: multiple queues can receive the same message
        # 3. Reliability: if the app goes down, messages will still be in the queue
        # 4. Speed: the delivery of the message is fast!

        # Publish the search term in a message to a SNS topic
        Publish::MessagePublishingService.call(search_term: search_term)

        # An external service or app polls a SQS queue that is subscribed to the SNS topic
        # and handles the search term before deleting the message from the queue
        Subscribe::MessagePollingService.call

        render json: { results: true }, status: :ok
      rescue Exception => e
        render json: { errors: [{ title: e.class.to_s, code: '400', detail: e.message }] }, status: :bad_request
      end

      private

      def search_params
        params.permit(:q).to_h
      end

      def search_term
        search_params.fetch('q', nil)
      end
    end
  end
end
