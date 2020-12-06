class Publish::MessagePublishingService
  def initialize(search_term: search_term)
    @search_term = search_term
  end

  def call
    return if @search_term.blank?

    publish_message

    true
  end

  private

  def publish_message
    sns = Aws::SNS::Client.new(credentials)

    sns.publish(
      topic_arn:  ENV['AWS_SNS_TOPIC_ARN'],
      message:    { search_term: @search_term }.to_json
    )
  end

  def credentials
    {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  end
end
