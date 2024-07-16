module Craigslist
  class UrlBuilder
    attr_reader :url
    def initialize(city:, site_section:, query_value: nil)
      @url = build(city, site_section, query_value)
    end

    private

    def build(city, site_section, query_value)
      url = "https://#{CITIES[city.upcase.to_sym]}.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}"
      query_value.nil? ? url : url.concat("?query=#{query_value}")
    end
  end
end