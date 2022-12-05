FROM ruby:3.0.5

RUN set -x && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN set -x && apt-get update -qq && \
  apt-get install -yq build-essential yarn

RUN mkdir /bandapp
WORKDIR /bandapp
COPY Gemfile /bandapp/Gemfile
COPY Gemfile.lock /bandapp/Gemfile.lock

RUN bundle install
COPY . /bandapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
