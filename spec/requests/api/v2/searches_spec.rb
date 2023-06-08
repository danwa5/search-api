require 'rails_helper'

RSpec.describe 'Search', type: :request do
  describe 'POST /api/v2/search' do
    context 'when request returns success' do
      example do
        expect(Publish::MessagePublishingService).to receive(:call)
          .with(search_term: 'pizza').once

        expect(Subscribe::MessagePollingService).to receive(:call).once

        post api_v2_search_path, params: 'q=pizza'

        expect(response).to have_http_status(200)
      end
    end

    context 'when request returns failure' do
      example do
        expect(Publish::MessagePublishingService).to receive(:call).and_raise

        post api_v2_search_path

        expect(response).to have_http_status(400)
      end
    end
  end
end
