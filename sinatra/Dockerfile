FROM ruby:2.7

RUN gem install sinatra

WORKDIR /root/data

RUN cd /root && git clone https://github.com/mruby/mruby.git && cd mruby && make

COPY data .

EXPOSE 4567

CMD ["ruby", "main.rb"]

