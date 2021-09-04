FROM ruby:2.7.3

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

RUN apt-get update -qq && \
    apt-get install -y postgresql-client \
    build-essential \
    libpq-dev \
    sudo \
    nginx && \
    gem install bundler:2.0.1
WORKDIR /app
COPY Gemfile* /app/
COPY Gemfile.lock* /app/
RUN bundle install
COPY . /app
RUN mkdir -p tmp/sockets

RUN groupadd nginx
RUN useradd -g nginx nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
