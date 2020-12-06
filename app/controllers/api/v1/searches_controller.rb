module Api
  module V1
    class SearchesController < ApplicationController
      # POST /api/v1/search
      def create
        # As an example, we're directly tracking the frequency of a search term here
        # However, in a production environment that needs to be scalable to handle thousands of searches
        # per minute, this API would need to send the search term to a separate, external service by
        # either making an API request or sending the search term in a message via SNS/SQS
        st = AddSearchTerm.new(term: search_term).call
        render json: { results: st }, status: :ok

        # Solution for production:
        # 1. This API publishes the search term in a message to a SNS topic
        #
        # Publish::MessagePublishingService.new(search_term: search_term).call

        # 2. An external service polls a SQS queue that is subscribed to the SNS topic and handles the
        #    search term in the database before deleting the message from the queue
        #
        # Subscribe::MessagePollingService.new.call
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
