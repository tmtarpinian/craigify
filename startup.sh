#!/bin/bash

cd /craigs_scrape/

# Set the permissions for run_notification_generator.rb
chmod 755 run_notification_generator.rb

# Zip the lib and bin directories for the notification_generator lambda
zip -r notification_generator_lambda_code.zip lib run_notification_generator.rb Gemfile Gemfile.lock vendor

# Zip files for the email_via_sns_lambda_code lambda
zip -r email_via_sns_lambda_code.zip send_email_via_sns.rb Gemfile Gemfile.lock vendor

# Keep the container running
exec tail -f /dev/null