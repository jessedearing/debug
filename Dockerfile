FROM ubuntu:latest

RUN apt-get update && apt-get install -y dnsutils netcat curl vim zsh \
    net-tools strace dnstracer traceroute tcptraceroute iproute2 python3 \
    postgresql-client tmux awscli jq \
    && apt-get clean
RUN echo set -o vi >> /etc/zsh/zshrc
RUN echo set -o interactivecomments >> /etc/zsh/zshrc
RUN echo alias l="ls -la" >> /etc/zsh/zshrc
RUN mkdir -p /var/run/tmux
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
