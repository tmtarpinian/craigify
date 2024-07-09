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
    let(:notification_generator) { Craigslist::NotificationGenerator.new({ city: 'DETROIT', site_section: site_section, notification_type: 'email' }) }
    let(:html) { File.read(File.join(File.dirname(__FILE__), 'labor_gigs_mock_response.html')) }

    xit 'calls parse_craigslist_page' do
      
      postings_builder = described_class.new(notification_generator, html)
      expect(postings_builder).to receive(:parse_craigslist_page).with(html)
      # postings_builder.parse_postings_in_html
    end

    xit 'calls find_listings_with_search_term' do
      
      postings_builder = described_class.new(notification_generator, html)
      allow(postings_builder).to receive(:parse_craigslist_page).and_return([])
      expect(postings_builder).to receive(:find_listings_with_search_term).with([])
      # postings_builder.parse_postings_in_html
    end

    xit 'returns an array of postings' do
      
      postings_builder = described_class.new(notification_generator, html)

      expect(postings_builder.parse_postings_in_html).to eq([{
        title: 'Title',
        date: Time.now.strftime('%m-%d-%Y'),
        url: 'https://detroit.craigslist.org/lbg/d/handyman/123456.html',
        location: 'Detroit',
        price: '$10',
        pid: '123456'
      }])
    end
  end
end