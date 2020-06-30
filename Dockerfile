FROM ubuntu:latest

RUN apt-get update && apt-get install -y dnsutils netcat curl vim zsh \
    net-tools strace dnstracer traceroute tcptraceroute iproute2 python3 \
    postgresql-client tmux awscli jq \
    && apt-get clean \
    && curl -LO https://dl.k8s.io/v1.18.5/kubernetes-client-linux-amd64.tar.gz \
    && echo "01e9c71d65c4513c03b22b2b036c3e92875fa4ebdb43b4909a6b21608093d280d9f71953f9656b3728019bdc8cb6bbf864de3c6a3eb94d807ec0330dbccfa005 kubernetes-client-linux-amd64.tar.gz" |  sha512sum -c \
    && tar xzvf kubernetes-client-linux-amd64.tar.gz \
    && mv kubernetes/client/bin/kubectl /usr/local/bin/kubectl \
    && rm -rf kubernetes/ kubernetes-client-linux-amd64.tar.gz


RUN echo set -o vi >> /etc/zsh/zshrc
RUN echo set -o interactivecomments >> /etc/zsh/zshrc
RUN echo alias l="ls -la" >> /etc/zsh/zshrc
RUN mkdir -p /var/run/tmux
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
