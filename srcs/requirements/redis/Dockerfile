FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y build-essential tcl wget && \
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xzf redis-stable.tar.gz && \
    cd redis-stable && \
    make && make install

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]