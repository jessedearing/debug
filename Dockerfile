FROM ubuntu:latest

RUN apt-get update && apt-get install -y dnsutils netcat curl vim zsh net-tools strace dnstracer traceroute tcptraceroute iproute2 python3 postgresql-client \
    && apt-get clean
RUN echo set -o vi >> /etc/zsh/zshrc
ENTRYPOINT ["/usr/bin/zsh"]
