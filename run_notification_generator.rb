require_relative 'lib/Craigslist/notification_generator'

def lambda_handler(event:, context:)
  search_keywords = ENV['SEARCH_KEYWORDS'].split(',')
  Craigslist::NotificationGenerator.new({ city: "DETROIT", site_section: "LABOR_GIGS", search_keywords: search_keywords, notification_type: 'email' }).run
end
