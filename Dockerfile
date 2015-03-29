FROM litaio/ruby
MAINTAINER "Niko Kurtti niko@salaliitto.com"
 
RUN apt-get update
RUN apt-get install -y redis-server libssl-dev git


RUN groupadd -r tohtori && useradd --create-home -r -g tohtori tohtori

ADD . /home/tohtori/tohtori
WORKDIR /home/tohtori/tohtori

RUN chown -R tohtori:tohtori /home/tohtori

RUN gem install bundler

RUN bundle install --without development test debug

RUN su tohtori -c "mv /home/tohtori/tohtori/config/settings.production.yml /home/tohtori/tohtori/config/settings.yml"

CMD service redis-server start && su tohtori -c "ENV=production bundle exec lita start"
