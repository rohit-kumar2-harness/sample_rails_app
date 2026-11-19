FROM ruby:3.3.0-bookworm
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential libpq-dev nodejs postgresql-client yarn \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir /sample_rails_application
WORKDIR /sample_rails_application
COPY Gemfile /sample_rails_application/Gemfile
COPY Gemfile.lock /sample_rails_application/Gemfile.lock
COPY package.json /sample_rails_application/package.json
COPY yarn.lock /sample_rails_application/yarn.lock
RUN gem install bundler -v '~> 2.5'
RUN bundle install
RUN yarn install --check-files
COPY . /sample_rails_application
EXPOSE 3000

#CMD ["rails", "server", "-b", "0.0.0.0"]