ARG RUBY_VERSION=2.7
FROM ruby:$RUBY_VERSION

# Install google-chrome-stable.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable

# Install ChromeDriver. Major version must match google-chrome-stable.
ARG CHROMEDRIVER_VERSION=79.0.3945.36
RUN wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN rm chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver

# Copies the host directory.
COPY . /app/

# Work directory inside of the container.
WORKDIR /app

# Install gems.
RUN gem install bundler rake
RUN bundle update --bundler
RUN bundle install