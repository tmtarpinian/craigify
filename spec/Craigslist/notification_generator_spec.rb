require 'spec_helper'

describe 'CraigsList::NotificationGenerator' do
  let(:site_section) {'LABOR_GIGS'}

  describe 'validations' do
    it 'raises an error if city is missing' do
      expect { Craigslist::NotificationGenerator.new({site_section: site_section, notification_type: 'text'}) }.to raise_error(ArgumentError, 'Missing required arguments')
    end

    it 'raises an error if site_section is missing' do
      expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', notification_type: 'email'}) }.to raise_error(ArgumentError, 'Missing required arguments')
    end

    it 'raises an error if site_section is invalid' do
      expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: 'INVALID', notification_type: 'email'}) }.to raise_error(ArgumentError, 'Invalid site section')
    end

    it 'raises an error if city is invalid' do
      expect { Craigslist::NotificationGenerator.new({city: 'INVALID', site_section: site_section, notification_type: 'email'}) }.to raise_error(ArgumentError, 'Invalid city')
    end

    it 'raises an error if notification_type is invalid' do
      expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'invalid'}) }.to raise_error(ArgumentError, 'Invalid notification type')
    end

    it 'does not raise an error if city and site_section are valid' do
      expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'}) }.not_to raise_error
    end

    it 'does not raise an error if notification_type is valid' do
      expect { Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'text'}) }.not_to raise_error
    end

  end

  describe 'initialization' do
    it 'has a city attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.city).to eq('DETROIT')
    end

    it 'has a site_section attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.site_section).to eq('LABOR_GIGS')
    end

    it 'has a notification_type attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator.notification_type).to eq('email')
    end

    it 'has a search_keywords attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, search_keywords: ['handyman'], notification_type: 'email'})
      expect(notification_generator.search_keywords).to eq(['handyman'])
    end

    it 'has a query_value attribute' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, query_value: 'handyman', notification_type: 'email'})
      expect(notification_generator.query_value).to eq('handyman')
    end
  end

  describe 'run' do
    describe 'when the notification_type is email' do
      xit 'calls the trigger_email_notifications method' do
        notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
        expect(notification_generator).to receive(:trigger_email_notifications)
        notification_generator.run
      end
    end

    xit 'calls Craigslist::UrlBuilder.new.url' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect_any_instance_of(Craigslist::UrlBuilder).to receive(:url)
      notification_generator.run
    end

    it 'calls scrape_craigslist' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect(notification_generator).to receive(:scrape_craigslist)
      notification_generator.run
    end

    xit 'calls Craigslist::PostingsBuilder.new.parse_postings_in_html' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      expect_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html)
      notification_generator.run
    end

    it 'does not call trigger_email_notifications if craigslist_postings is empty' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      allow_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html).and_return([])
      expect(notification_generator).not_to receive(:trigger_email_notifications)
      notification_generator.run
    end

    it 'returns nil if craigslist_postings is empty' do
      notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
      allow_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html).and_return([])
      expect(notification_generator.run).to be_nil
    end

    describe 'returns a hash of craigslist_postings' do
      let(:craigslist_postings) {[
        {
          title: 'Handyman',
          date: Time.now.strftime('%m-%d-%Y'),
          url: 'https://detroit.craigslist.org/lbg/d/handyman/1234567890.html',
          location: 'Detroit',
          price: '$100',
          pid: '1234567890'
        }
      ]}
      xit 'calls trigger_email_notifications if craigslist_postings is not empty' do
        notification_generator = Craigslist::NotificationGenerator.new({city: 'DETROIT', site_section: site_section, notification_type: 'email'})
        allow_any_instance_of(Craigslist::PostingsBuilder).to receive(:parse_postings_in_html).and_return(craigslist_postings)
        expect(notification_generator).to receive(:trigger_email_notifications)
        notification_generator.run
      end
    end
  end
end