FROM ubuntu:latest

RUN apt-get update && apt-get install -y dnsutils netcat curl vim zsh \
    net-tools strace dnstracer traceroute tcptraceroute iproute2 python3 \
    postgresql-client tmux awscli jq \
    && apt-get clean \
    && curl -LO https://dl.k8s.io/v1.18.1/kubernetes-client-linux-amd64.tar.gz \
    && echo "37e664e40bb31765572215cf262a5c9bbc7748d158d0db58dbec2d5e593b54d71586af77296eda1cec2a2230b1d27260c51f6410b83afeeafc3c5354c308b4c4 kubernetes-client-linux-amd64.tar.gz" |  sha512sum -c \
    && tar xzvf kubernetes-client-linux-amd64.tar.gz \
    && mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
    && rm -rf kubernetes/


RUN echo set -o vi >> /etc/zsh/zshrc
RUN echo set -o interactivecomments >> /etc/zsh/zshrc
RUN echo alias l="ls -la" >> /etc/zsh/zshrc
RUN mkdir -p /var/run/tmux
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
