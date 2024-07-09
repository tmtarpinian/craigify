# require_relative '../lib/Craigslist/notification_generator'
require_relative 'lib/Craigslist/notification_generator' #use for local testing

def lambda_handler(event:, context:)
  Craigslist::NotificationGenerator.new({ city: "DETROIT", site_section: "LABOR_GIGS", search_keywords: ['handyman'], notification_type: 'email' }).run
end
