require 'spec_helper'

describe 'CraigsList::NotificationGenerator' do
  let(:site_section) {'LABOR_GIGS'}

  describe 'initialization' do
    it 'has a notification_type attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.notification_type).to eq('email')
    end

    it 'has a query_value attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, query_value: 'handyman', notification_type: 'email'})
      expect(notification_generator.query_value).to eq('handyman')
    end

    it 'has a site_section attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.site_section).to eq('LABOR_GIGS')
    end

    it 'has a search_keywords attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, search_keywords: ['handyman'], notification_type: 'email'})
      expect(notification_generator.search_keywords).to eq(['handyman'])
    end

    it 'has a city attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.city).to eq('DETROIT')
    end
  end

  describe 'validations' do
    describe 'for attribute presence' do
      it 'raises an error if city is missing' do
        expect { Craigslist::NotificationGenerator.new({site_section: site_section, notification_type: 'text'}) }.to raise_error(ArgumentError, 'Missing city, site_secion, or notification type')
      end

      it 'raises an error if site_section is missing' do
        expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', notification_type: 'email'}) }.to raise_error(ArgumentError, 'Missing city, site_secion, or notification type')
      end

      it 'raises an error if notification_type is missing' do
        expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section}) }.to raise_error(ArgumentError, 'Missing city, site_secion, or notification type')
      end
    end

    describe 'for attribute validity' do

      it 'raises an error if site_section is invalid' do
        expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: 'INVALID', notification_type: 'email'}) }.to raise_error(ArgumentError, 'Invalid site section')
      end

      it 'raises an error if city is invalid' do
        expect { Craigslist::NotificationGenerator.new({city: 'INVALID', site_section: site_section, notification_type: 'email'}) }.to raise_error(ArgumentError, 'Invalid city')
      end

      it 'raises an error if notification_type is invalid' do
        expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'invalid'}) }.to raise_error(ArgumentError, 'Invalid notification type')
      end
    end
  end


  describe 'run' do
    let(:site_section) {'LABOR_GIGS'}
    let(:notification_generator) { Craigslist::NotificationGenerator.new({ city: 'DETROIT', site_section: site_section, notification_type: 'email' }) }
    let(:html) { File.read(File.join(File.dirname(__FILE__), 'labor_gigs_mock_response.html')) }
    let(:postings_builder) { described_class.new(notification_generator, html) }

    it 'returns an empty array if craigslist_postings is empty' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      allow_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html).and_return([])
      expect(notification_generator.run).to be_empty
    end

    it 'returns a hash of craigslist_postings' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      allow_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html).and_return(
        [
          {
            :date=>"07-14-2024",
            :keyword=>"handy",
            :location=>"Tireman",
            :pid=>"7762543982",
            :price=>"$0",
            :title=>"Looking to hire handyman as soon as possible",
            :url=>"https://detroit.craigslist.org/wyn/lbg/d/detroit-looking-to-hire-handyman-as/7762543982.html"
          }
        ]
      )

      allow_any_instance_of(Craigslist::NotificationGenerator).to receive(:trigger_notification).and_return(
        [
          {
            :date=>"07-14-2024",
            :keyword=>"handy",
            :location=>"Tireman",
            :pid=>"7762543982",
            :price=>"$0",
            :title=>"Looking to hire handyman as soon as possible",
            :url=>"https://detroit.craigslist.org/wyn/lbg/d/detroit-looking-to-hire-handyman-as/7762543982.html"
          }
        ]
      )

      expect(notification_generator.run).to eq(
        [
          {
            :date=>"07-14-2024",
            :keyword=>"handy",
            :location=>"Tireman",
            :pid=>"7762543982",
            :price=>"$0",
            :title=>"Looking to hire handyman as soon as possible",
            :url=>"https://detroit.craigslist.org/wyn/lbg/d/detroit-looking-to-hire-handyman-as/7762543982.html"
          }
        ]
      )
    end
  end
end