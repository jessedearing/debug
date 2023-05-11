FROM docker.io/library/archlinux:latest as builder
ADD ./grpcurl /grpcurl
RUN curl -L https://www.archlinux.org/mirrorlist/\?country\=US\&protocol=http\&protocol\=https\&ip_version\=4 | sed -e 's/^#Server/Server/' -e '/^#/d' | tee /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    pacman --noconfirm -S binutils fakeroot go git gcc && \
    useradd -m debugbuilder && \
    chown -R debugbuilder grpcurl && \
    cd grpcurl && \
    su -s /bin/bash -c makepkg debugbuilder && \
    mv ./*.zst ./grpcurl.zst

FROM docker.io/library/archlinux:latest
ENV KAFKA_VERSION=3.4.0
RUN curl -L https://www.archlinux.org/mirrorlist/\?country\=US\&protocol=http\&protocol\=https\&ip_version\=4 | sed -e 's/^#Server/Server/' -e '/^#/d' | tee /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    pacman --noconfirm -S dnsutils netcat curl neovim zsh jq aws-cli kubectl jre-openjdk tcpdump postgresql rclone sshpass && \
    curl -LO https://apache.osuosl.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz && \
    tar xzvf kafka_2.13-$KAFKA_VERSION.tgz && \
    mv kafka_2.13-$KAFKA_VERSION /opt/kafka && \
    rm -rf kafka_2.13-$KAFKA_VERSION.tgz && \
    rm -rf /var/cache/pacman/*

COPY --from=builder /grpcurl/grpcurl.zst /grpcurl.zst
COPY tools/check-clock-skew.sh /usr/local/bin/check-clock-skew.sh

RUN pacman --noconfirm -U /grpcurl.zst && \
    rm -f /grpcurl.zst && \
    echo set -o vi | tee -a /etc/zsh/zshrc && \
    echo set -o interactivecomments | tee -a /etc/zsh/zshrc && \
    echo alias l="ls -la" | tee -a /etc/zsh/zshrc && \
    echo PATH=$PATH:/opt/kafka/bin | tee -a /etc/zsh/zshrc && \
    echo export KAFKA_HEAP_OPTS="-Xmx1024m -Xms1024m" | tee -a /etc/zsh/zshrc && \
    mkdir -p /var/run/tmux && \
    echo "security.protocol=SSL" | tee kafka-client.properties
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
