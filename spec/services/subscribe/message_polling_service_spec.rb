require 'rails_helper'

RSpec.describe Subscribe::MessagePollingService do
  let(:sqs_client) { double(:sqs_client) }
  let(:messages) do
    [
      double(body: '{"Message": "{ \"search_term\": \"pizza\" }" }', receipt_handle: 'abc'),
      double(body: '{"Message": "{ \"search_term\": \"chatgpt\" }" }', receipt_handle: 'def'),
    ]
  end

  describe '#call' do
    before do
      allow(Aws::SQS::Client).to receive(:new).and_return(sqs_client)
      allow(sqs_client).to receive_message_chain(:get_queue_url, :queue_url).and_return(nil)
    end

    it 'polls and deletes messages' do
      expect(sqs_client).to receive_message_chain(:receive_message, :messages)
        .and_return(messages)

      expect(AddSearchTerm).to receive(:call).with(term: 'pizza').once.and_return(true)
      expect(AddSearchTerm).to receive(:call).with(term: 'chatgpt').once.and_return(true)

      expect(sqs_client).to receive(:delete_message).with(
        queue_url: nil,
        receipt_handle: 'abc'
      ).once

      expect(sqs_client).to receive(:delete_message).with(
        queue_url: nil,
        receipt_handle: 'def'
      ).once

      subject.call
    end
  end
end
