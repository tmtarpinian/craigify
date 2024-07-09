require 'spec_helper'

describe Craigslist::UrlBuilder do
  let(:site_section) {'LABOR_GIGS'}

  it 'initializes with a city, site_section, and query_value' do
    url_builder = Craigslist::UrlBuilder.new(city: 'DETROIT', site_section: 'LABOR_GIGS', query_value: nil)
    expect(url_builder.url).to eq("https://detroit.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}")
  end

  it 'has a url attribute' do
    url_builder = Craigslist::UrlBuilder.new(city: 'DETROIT', site_section: 'LABOR_GIGS', query_value: nil)
    expect(url_builder.url).to eq("https://detroit.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}")
  end

  it 'includes a query_value in the url if one is provided' do
    url_builder = Craigslist::UrlBuilder.new(city: 'DETROIT', site_section: 'LABOR_GIGS', query_value: 'handyman')
    expect(url_builder.url).to eq("https://detroit.craigslist.org/search/#{SITE_SECTIONS[site_section.upcase.to_sym]}?query=handyman")
  end
end