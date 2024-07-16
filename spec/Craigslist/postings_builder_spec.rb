require 'spec_helper'

RSpec.describe Craigslist::PostingsBuilder do
  describe '#initialize' do
    let(:site_section) {'LABOR_GIGS'}
    let(:notification_generator) { Craigslist::NotificationGenerator.new({ city: 'DETROIT', site_section: site_section, notification_type: 'email' }) }
    let(:html) { File.read(File.join(File.dirname(__FILE__), 'labor_gigs_mock_response.html')) }
    let(:postings_builder) { described_class.new(notification_generator, html) }

    it 'initializes a new instance of PostingsBuilder' do
      expect(postings_builder).to be_a(Craigslist::PostingsBuilder)
    end

    it 'sets a notification_generator attribute' do
      expect(postings_builder.notification_generator).to eq(notification_generator)
    end

    it 'sets an html attribute' do
      expect(postings_builder.html).to eq(html)
    end
  end

  describe '#parse_postings_in_html' do
    let(:site_section) {'LABOR_GIGS'}
    let(:html) { File.read(File.join(File.dirname(__FILE__), 'labor_gigs_mock_response.html')) }
    let(:notification_generator) { Craigslist::NotificationGenerator.new({ city: 'DETROIT', site_section: site_section, notification_type: 'email', search_keywords: ['handy'] }) }
    let(:notification_generator_2) { Craigslist::NotificationGenerator.new({ city: 'DETROIT', site_section: site_section, notification_type: 'email', search_keywords: ['paint'] }) }
    let(:current_date) { Time.now.strftime('%m-%d-%Y') }

    it 'returns an array of postings' do
      postings_builder = described_class.new(notification_generator, html)
      expect(postings_builder.parse_postings_in_html).to eq(
        [
          {
            :date=> current_date,
            :keyword=>"handy",
            :location=>"Tireman",
            :pid=>"7762543982",
            :price=>"$0",
            :title=>"Looking to hire handyman as soon as possible",
            :url=>"https://detroit.craigslist.org/wyn/lbg/d/detroit-looking-to-hire-handyman-as/7762543982.html"
          },
          {
            :date=> current_date,
            :keyword=>"handy",
            :location=>"Eastpointe",
            :pid=>"7760206604",
            :price=>"$0",
            :title=>"Looking for handyman / contractors",
            :url=>"https://detroit.craigslist.org/mcb/lbg/d/eastpointe-looking-for-handyman/7760206604.html"
          },
          {
            :date=> current_date,
            :keyword=>"handy",
            :location=>"Eastside",
            :pid=>"7759586911",
            :price=>"$0",
            :title=>"Handyman Wanted",
            :url=>"https://detroit.craigslist.org/wyn/lbg/d/fraser-handyman-wanted/7759586911.html"
          },
          {
            :date=> current_date,
            :keyword=>"handy",
            :location=>"macomb county",
            :pid=>"7756245124",
            :price=>"$0",
            :title=>"skill repair/handyman for rental home improvement",
            :url=> "https://detroit.craigslist.org/mcb/lbg/d/saint-clair-shores-skill-repair/7756245124.html"
          }
        ]
      )
      postings_builder = described_class.new(notification_generator_2, html)
      expect(postings_builder.parse_postings_in_html).to eq(
      [
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Detroit",
          :pid=>"7761740004",
          :title=>"Painter",
          :price=>"$0",
          :url=> "https://detroit.craigslist.org/wyn/lbg/d/detroit-painter/7761740004.html"
        },
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Royal Oak",
          :pid=>"7758606428",
          :title=>"I need a painter and lawn care company",
          :price=>"$0",
          :url=> "https://detroit.craigslist.org/okl/lbg/d/royal-oak-need-painter-and-lawn-care/7758606428.html"
        },
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Macomb County",
          :pid=>"7758435698",
          :title=>"FULL TIME PAINTER NEEDED",
          :price=>"$0",
          :url=> "https://detroit.craigslist.org/mcb/lbg/d/harrison-township-full-time-painter/7758435698.html"
        },
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Detroit",
          :pid=>"7758361566",
          :title=>"Law services, gutters, and paint",
          :price=>"$0",
          :url=> "https://detroit.craigslist.org/wyn/lbg/d/detroit-law-services-gutters-and-paint/7758361566.html"
        },
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Oakland County",
          :pid=>"7758098814",
          :price=>"$0",
          :title=>"Hiring Skilled Painters",
          :price=>"$0",
          :url=>"https://detroit.craigslist.org/okl/lbg/d/royal-oak-hiring-skilled-painters/7758098814.html"},
        {
          :date=> current_date,
          :keyword=>"paint",
          :location=>"Pontiac",
          :pid=>"7757978521",
          :price=>"$0",
          :title=>"Painter/ Trimmer",
          :price=>"$0",
          :url=>"https://detroit.craigslist.org/okl/lbg/d/pontiac-painter-trimmer/7757978521.html"
        }
      ]
      )
    end

    it 'returns an array of hashes with the correct keys' do
      postings_builder = described_class.new(notification_generator, html)
      postings = postings_builder.parse_postings_in_html
      expect(postings.first.keys).to eq([:title, :date, :url, :location, :price, :pid, :keyword])
    end
  end
end