FROM ruby:2.6.4

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /rails_tyutorial
WORKDIR /rails_tyutorial
COPY Gemfile /rails_tyutorial/Gemfile
COPY Gemfile.lock /rails_tyutorial/Gemfile.lock
RUN bundle install
COPY . /rails_tyutorial

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
