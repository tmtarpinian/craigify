module Craigslist
  class InvokeEmailNotificationLambda

    def initialize(craigslist_post_hash)
      # craigslist_post_hash => {
      #     title: title,
      #     date: Time.now.strftime('%m-%d-%Y'),
      #     url: format_href(result),
      #     location: format_location(result),
      #     price: format_price(result),
      #     pid: format_pid(result),
      #   }
      puts "Invoking email notification lambda with the following Craigslist posting: #{craigslist_post_hash}"
      invoke_notification_lambda(craigslist_post_hash)
    end

    private

    def invoke_notification_lambda(craigslist_post_hash)
      message = format_message(craigslist_post_hash)
      subject = format_subject(craigslist_post_hash)
        lambda_client = Aws::Lambda::Client.new(region: 'us-east-1')
        lambda_client.invoke({
          function_name: 'sendEmailBySns',
          invocation_type: 'Event',
          payload: { subject: subject, message: message }.to_json
        })
    end

    def format_message(craigslist_post_hash)
      "Craiglist #{query_value} post for #{craigslist_post_hash[:location]}. Click here #{craigslist_post_hash[:url]}"
    end

    def format_subject(craigslist_post_hash)
      "New Craigslist #{query_value} post in #{craigslist_post_hash[:location]}"
    end
  end
end
