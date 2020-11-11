FROM edenhill/kafkacat:1.6.0 AS kafkacat

FROM archlinux:latest
COPY --from=kafkacat /usr/bin/kafkacat /usr/bin/kafkacat
RUN curl -L https://www.archlinux.org/mirrorlist/\?country\=US\&protocol=http\&protocol\=https\&ip_version\=4 | sed -e 's/^#Server/Server/' -e '/^#/d' | tee /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    pacman --noconfirm -S dnsutils netcat curl neovim zsh jq aws-cli kubectl jre-openjdk && \
    curl -L https://github.com/moparisthebest/wireguard-proxy/releases/download/v0.1.1/wireguard-proxy-v0.1.1-x86_64-unknown-linux-gnu.tar.gz -o wireguard-proxy.tar.gz && \
    tar xzvf wireguard-proxy.tar.gz && \
    mv wireguard-proxy* /usr/local/bin && \
    curl -LO https://apache.osuosl.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz && \
    tar xzvf kafka_2.13-2.6.0.tgz && \
    mv kafka_2.13-2.6.0 /opt/kafka && \
    rm -rf kafka_2.13-2.6.0.tgz && \
    rm -rf /var/cache/pacman/*


RUN echo set -o vi >> /etc/zsh/zshrc
RUN echo set -o interactivecomments >> /etc/zsh/zshrc
RUN echo alias l="ls -la" >> /etc/zsh/zshrc
RUN echo PATH=$PATH:/opt/kafka/bin >> /etc/zsh/zshrc
RUN mkdir -p /var/run/tmux
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
