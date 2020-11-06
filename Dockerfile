ARG RUBY_VERSION=2.7
FROM ruby:$RUBY_VERSION

# Install google-chrome-stable.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable

# Use ssh key provided as a build arg
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh && \
    echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# Install ChromeDriver. Major version must match google-chrome-stable.
ARG CHROMEDRIVER_VERSION=79.0.3945.36
RUN wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN rm chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver


#make sure we have a folder call /app
RUN mkdir /app

# Work directory inside of the container.
WORKDIR /app

# Copies the host directory.
COPY . /app/

# Install gems.
RUN gem install bundler rake
RUN bundle update --bundler
RUN bundle install
