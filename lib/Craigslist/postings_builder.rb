module Craigslist
  class PostingsBuilder
    attr_reader :notification_generator, :html

    def initialize(notification_generator, html)
      @notification_generator = notification_generator
      @html = html
    end

    def parse_postings_in_html
      parsed_results = parse_craigslist_page(html)
      puts "Total Postings Scraped: #{parsed_results.size}"
      find_listings_with_search_term(parsed_results)
    end

    private

    def parse_craigslist_page(html)
      doc = Nokogiri::HTML(html)
      doc.css('ol.cl-static-search-results li.cl-static-search-result')
    end

    def find_listings_with_search_term(parsed_results)
      results = []
      parsed_results.each do |result|

        title_element = result.at_css('.title')
        title = title_element.text.strip
        keyword = notification_generator.search_keywords.find { |keyword| title.downcase.include?(keyword.downcase) }
        next unless keyword
        
        results << {
          title: title,
          date: Time.now.strftime('%m-%d-%Y'),
          url: format_href(result),
          location: format_location(result),
          price: format_price(result),
          pid: format_pid(result),
          keyword: keyword
        }
      end
      results
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

    def format_price(element)
      element.at_css('div.price').children.text.strip
    end
  end
end
