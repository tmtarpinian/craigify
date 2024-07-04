
require 'net/http'
require 'nokogiri'
require './constants'
require 'pry'
require 'aws-sdk-lambda'

class CraigslistScraper
  attr_reader :craigslist_url, :query_value
  def initialize(city:, site_section:, query_value: nil)
    @query_value = query_value
    @craigslist_url = build_url(city, site_section, query_value)
  end

  def run
    uri = URI(craigslist_url)
    response = Net::HTTP.get(uri)
    handle_response(response)
  end

  private

  def build_url(city, site_section, query_value)
    "https://#{CITIES[city.upcase.to_sym]}.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}"

    # TODO: add query params or treat as a subclass of CraigslistScraper
    # url = "https://#{CITIES[city.upcase.to_sym]}.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}"
    # url.concat!("?query=#{query_value}") unless query_value.nil?
    # url
  end

  def handle_response(html)
    parsed_results = parse_craigslist_page(html)
    puts "Total results: #{parsed_results.size}"
    results_array = find_listings_with_search_term(parsed_results)

  end

  def parse_craigslist_page(html)
    doc = Nokogiri::HTML(html)
    doc.css('ol.cl-static-search-results li.cl-static-search-result')
  end

  def find_listings_with_search_term(parsed_results)
    results = []
    parsed_results.each do |result|

      title_element = result.at_css('.title')
      title = title_element.text.strip
      next unless title.include?(query_value)

      results << {
        title: title,
        date: Time.now.strftime('%m-%d-%Y'),
        href: format_href(result),
        location: format_location(result),
        pid: format_pid(result),
      }
    end
    results.each { |result| puts result }
    results
      # invoke_text_message_lambda(title, href, data_pid)
  end

  def format_href(element)
    element.at_css('a')['href']
  end

  def format_pid(element)
    href = format_href(element)
    href.match(/(?<=\/)\d+(?=\.html)/)[0]
  end

  def format_location(element)
    element.at_css('div.location').children.text.strip
  end


  def invoke_text_message_lambda
    # lambda_client = Aws::Lambda::Client.new(region: 'us-east-1')
    # lambda_client.invoke({
    #   function_name: 'send_text_message',
    #   invocation_type: 'Event'
    # })
  end
end

# scraper = CraigslistScraper.new(city: "DETROIT", site_section: "LABOR_GIGS", query_value: "handyman")
# scraper.run
