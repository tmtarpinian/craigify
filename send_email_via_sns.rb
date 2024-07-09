require 'aws-sdk-sns'
require 'logger'

def send_email(event:, context:)
  sns_client = Aws::SNS::Client.new(region: 'us-east-1')
  topic_arn = ENV['TOPIC_ARN']
  subject = event['subject']
  message = event['message']

  # Set up logger
  logger = Logger.new($stdout)

  begin
    response = sns_client.publish({
      topic_arn: topic_arn,
      message: message,
      subject: subject
    })
    logger.info("Email sent! Message ID: #{response.message_id}")
  rescue Aws::SNS::Errors::ServiceError => e
    logger.error("Error sending email: #{e.message}")
  end
end
