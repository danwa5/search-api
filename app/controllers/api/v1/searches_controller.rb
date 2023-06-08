module Api
  module V1
    class SearchesController < ApplicationController
      # POST /api/v1/search
      def create
        # Call service object directly to add search term to the DB
        res = AddSearchTerm.call(term: search_term)
        render json: { results: res }, status: :ok
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
