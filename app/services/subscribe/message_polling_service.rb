class Subscribe::MessagePollingService
  def call
    messages = sqs_client.receive_message(queue_url: queue_url, max_number_of_messages: 10).messages

    messages.each do |msg|
      body = JSON.parse(msg.body)
      h = eval(body['Message'])
      term = h.fetch(:search_term, nil)

      res = AddSearchTerm.new(term: term).call
      delete_message(msg.receipt_handle) if res
    end
  end

  private

  def sqs_client
    @sqs_client ||= Aws::SQS::Client.new
  end

  def queue_url
    @queue_url ||= sqs_client.get_queue_url(queue_name: ENV['AWS_SQS_QUEUE_NAME']).queue_url
  end

  def delete_message(receipt_handle)
    sqs_client.delete_message({
      queue_url: queue_url,
      receipt_handle: receipt_handle
    })
  end
end
