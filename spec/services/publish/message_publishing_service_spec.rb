require 'rails_helper'

RSpec.describe Publish::MessagePublishingService do
  describe '#call' do
    context 'when search term is blank' do
      it 'returns nil' do
        expect(described_class.call(search_term: '')).to be_nil
      end
    end

    context 'when search term is given' do
      it 'publishes a message to SNS' do
        search_term = 'oat milk'

        sns_client = double
        expect(Aws::SNS::Client).to receive(:new).and_return(sns_client)

        expect(sns_client).to receive(:publish)
          .with(
            topic_arn: ENV['AWS_SNS_TOPIC_ARN'],
            message: { search_term: search_term }.to_json
          ).once

        expect(described_class.call(search_term: search_term)).to eq(true)
      end
    end
  end
end
