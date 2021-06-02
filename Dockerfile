FROM ruby:2.7.3

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /app
COPY Gemfile* /app/
COPY Gemfile.lock* /app/
RUN bundle install
COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]