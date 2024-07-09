require 'net/http'
require 'nokogiri'
require 'aws-sdk-lambda'
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
    end
    
    def run
      craigslist_url = Craigslist::UrlBuilder.new(
        city: city,
        site_section: site_section,
        query_value: query_value).url
      html = scrape_craigslist(craigslist_url)
      craigslist_postings = Craigslist::PostingsBuilder.new(self, html).parse_postings_in_html
      # craigslist_postings => {
      #     title: title,
      #     date: Time.now.strftime('%m-%d-%Y'),
      #     url: format_href(result),
      #     location: format_location(result),
      #     price: format_price(result),
      #     pid: format_pid(result),
      #   }
      send("trigger_#{notification_type}_notifications", craigslist_postings) unless craigslist_postings.empty?
    end

    private

    def validate_opts(opts)
      raise ArgumentError, 'Missing required arguments' unless opts[:city] && opts[:site_section] && opts[:notification_type]
      raise ArgumentError, 'Invalid site section' unless SITE_SECTIONS.keys.include?(opts[:site_section].upcase.to_sym)
      raise ArgumentError, 'Invalid city' unless CITIES.keys.include?(opts[:city].upcase.to_sym)
      raise ArgumentError, 'Invalid notification type' unless NOTIFICATION_TYPES.include?(notification_type)
    end

    def scrape_craigslist(craigslist_url)
      uri = URI(craigslist_url)
      Net::HTTP.get(uri)
    end

    def trigger_email_notifications(craigslist_postings)
      craigslist_postings.each { |craigslist_posting| Craigslist::InvokeEmailNotificationLambda.new(craigslist_posting) }
    end
  end
end