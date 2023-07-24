FROM ruby:2.7

WORKDIR /root/
RUN apt update && apt install -y bison 
RUN gem install sinatra
RUN gem install webrick

WORKDIR /root/
RUN git clone -b 2.1.0 https://github.com/mruby/mruby.git mruby-2.1 && \
    cd mruby-2.1 && \
    ./minirake && \
    mkdir -p /usr/local/mruby-2.1/bin/ && \
    cp bin/* /usr/local/mruby-2.1/bin/

WORKDIR /root/ 
RUN git clone -b 3.1.0 https://github.com/mruby/mruby.git mruby-3.1 && \
    cd mruby-3.1 && \
    ./minirake && \
    mkdir -p /usr/local/mruby-3.1/bin/ && \
    cp bin/* /usr/local/mruby-3.1/bin/

WORKDIR /root/ 
RUN git clone -b 3.2.0 https://github.com/mruby/mruby.git mruby-3.2 && \
    cd mruby-3.2 && \
    ./minirake && \
    mkdir -p /usr/local/mruby-3.2/bin/ && \
    cp bin/* /usr/local/mruby-3.2/bin/

WORKDIR /root/data
COPY data .
EXPOSE 4567

CMD ["ruby", "main.rb"]
