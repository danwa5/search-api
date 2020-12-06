require 'rails_helper'

RSpec.describe 'Search', type: :request do
  describe 'POST /api/v1/search' do
    context 'when request returns success' do
      example do
        expect_any_instance_of(AddSearchTerm).to receive(:call).and_return(true)

        post api_v1_search_path

        expect(response).to have_http_status(200)
      end
    end

    context 'when request returns failure' do
      example do
        expect_any_instance_of(AddSearchTerm).to receive(:call).and_raise

        post api_v1_search_path

        expect(response).to have_http_status(400)
      end
    end
  end
end
