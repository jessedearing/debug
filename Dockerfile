FROM archlinux:latest
RUN curl -L https://www.archlinux.org/mirrorlist/\?country\=US\&protocol=http\&protocol\=https\&ip_version\=4 | sed -e 's/^#Server/Server/' -e '/^#/d' | tee /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    pacman --noconfirm -S dnsutils netcat curl neovim zsh jq aws-cli kubectl jre-openjdk tcpdump postgresql && \
    curl -L https://github.com/moparisthebest/wireguard-proxy/releases/download/v0.1.1/wireguard-proxy-v0.1.1-x86_64-unknown-linux-gnu.tar.gz -o wireguard-proxy.tar.gz && \
    tar xzvf wireguard-proxy.tar.gz && \
    mv wireguard-proxy* /usr/local/bin && \
    curl -LO https://apache.osuosl.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz && \
    tar xzvf kafka_2.13-2.6.0.tgz && \
    mv kafka_2.13-2.6.0 /opt/kafka && \
    rm -rf kafka_2.13-2.6.0.tgz && \
    rm -rf /var/cache/pacman/*

RUN echo set -o vi | tee -a /etc/zsh/zshrc && \
    echo set -o interactivecomments | tee -a /etc/zsh/zshrc && \
    echo alias l="ls -la" | tee -a /etc/zsh/zshrc && \
    echo PATH=$PATH:/opt/kafka/bin | tee -a /etc/zsh/zshrc && \
    echo export KAFKA_HEAP_OPTS="-Xmx1024m -Xms1024m" | tee -a /etc/zsh/zshrc && \
    mkdir -p /var/run/tmux && \
    echo "security.protocol=SSL" | tee kafka-client.properties
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
