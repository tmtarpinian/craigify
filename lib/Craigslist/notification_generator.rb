require 'aws-sdk-lambda'
require 'logger'
require 'net/http'
require 'nokogiri'
require 'redis'
require_relative 'index'

module Craigslist
  class NotificationGenerator
    attr_reader :search_keywords, :site_section, :city, :query_value, :notification_type
    
    def initialize(opts = {})
      @notification_type = opts[:notification_type]
      @query_value = opts[:query_value]
      @site_section = opts[:site_section]
      @search_keywords = opts[:search_keywords]
      @city = opts[:city]
      validate_opts(opts)
      Logger.new($stdout).info("\nValidated options successfully...\n")
    end
    
    def run
      craigslist_url = Craigslist::UrlBuilder.new(
        city: city,
        site_section: site_section,
        query_value: query_value
      ).url

      Logger.new($stdout).info("\nCraigslist URL: #{craigslist_url}\n")
      html = scrape_craigslist(craigslist_url)
      Logger.new($stdout).info("\nScraped Craigslist URL successfully...\n")
      craigslist_postings = Craigslist::PostingsBuilder.new(self, html).parse_postings_in_html
      Logger.new($stdout).info("\nParsed Craigslist postings successfully...\n")
      trigger_notification(craigslist_postings)
    end

    private

    def validate_opts(opts)
      raise ArgumentError, 'Missing city, site_secion, or notification type' unless opts[:city] && opts[:site_section] && opts[:notification_type]
      raise ArgumentError, 'Invalid site section' unless SITE_SECTIONS.keys.include?(opts[:site_section].upcase.to_sym)
      raise ArgumentError, 'Invalid city' unless CITIES.keys.include?(opts[:city].upcase.to_sym)
      raise ArgumentError, 'Invalid notification type' unless NOTIFICATION_TYPES.include?(notification_type)
    end

    def scrape_craigslist(craigslist_url)
      begin
      uri = URI(craigslist_url)
      Net::HTTP.get(uri)
      rescue => e
        Logger.new($stdout).info("\nHTTP request failed #{e}")
      end
    end

    def trigger_notification(craigslist_postings)
      redis = initialize_redis 
      craigslist_postings.each do |craigslist_posting|
        # craigslist_posting => {
        #     title: title,
        #     date: Time.now.strftime('%m-%d-%Y'),
        #     url: format_href(result),
        #     location: format_location(result),
        #     price: format_price(result),
        #     pid: format_pid(result),
        #     keyword: keyword
        #   }

        cached_pid = redis.get(craigslist_posting[:pid])
        if cached_pid
          puts "PID #{craigslist_posting[:pid]} found in cache, skipping post..."
          next
        else
          redis.set(craigslist_posting[:pid], DateTime.now.to_s, ex: 35 * 24 * 60 * 60) # Expire after 35 days
          send("trigger_#{notification_type}_notifications", craigslist_posting)
        end
      end
    end

    def initialize_redis
      begin
        # Set up Redis connection
        Redis.new(
          host: ENV['REDIS_HOST'],
          port: ENV['REDIS_PORT'].to_i
        )
      rescue => e
        logger.error("Error connecting to Redis: #{e.message}")
      end
    end


    def trigger_email_notifications(craigslist_posting)
      Craigslist::InvokeEmailNotificationLambda.new(craigslist_posting)
    end
  end
end