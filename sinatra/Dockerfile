FROM ruby:2.7

RUN gem install sinatra

WORKDIR /root

RUN git clone https://github.com/mruby/mruby.git && cd mruby && make

COPY main.rb .

EXPOSE 4567

CMD ["ruby", "main.rb"]

