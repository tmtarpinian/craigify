FROM ruby:3.3.3-bullseye

# install rails dependencies
RUN apt-get update -qq && apt-get install -y build-essential \
curl \
libpq-dev \
nano \
postgresql-client \
unzip \
zip \
wget \
yarn && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs

# create a folder /scraper in the docker container and set as the working directory
RUN mkdir /craiglist_scraper
WORKDIR /craiglist_scraper

# Get some basic bash aliases set
RUN touch $HOME/.bashrc

RUN echo "alias ll='ls -alF'" >> $HOME/.bashrc && \
  echo "alias la='ls -A'" >> $HOME/.bashrc && \
  echo "alias l='ls -CF'" >> $HOME/.bashrc && \
  echo "alias q='exit'" >> $HOME/.bashrc && \
  echo "alias c='clear'" >> $HOME/.bashrc

# Copy the Gemfile from app root directory into the /scraper/ folder in the docker container
COPY Gemfile ./

# Run bundle install to install gems inside the gemfile
# RUN bundle install --verbose

RUN bundle install --path vendor/bundle


# Copy the rest of your app's source code from your host to your image filesystem.
COPY scrape.rb ./

# Copy the whole app
RUN zip -r scrape.zip scrape.rb Gemfile Gemfile.lock vendor

ENTRYPOINT ["tail", "-f", "/dev/null"]