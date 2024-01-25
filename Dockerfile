FROM docker.io/library/golang:1 AS http-server
WORKDIR /app
COPY go-httpserver .
RUN go build .

FROM docker.io/library/archlinux:latest
ENV KAFKA_VERSION=3.6.1
RUN curl -L https://www.archlinux.org/mirrorlist/\?country\=US\&protocol=http\&protocol\=https\&ip_version\=4 | sed -e 's/^#Server/Server/' -e '/^#/d' | tee /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    pacman --noconfirm -S dnsutils netcat curl neovim zsh jq aws-cli-v2 kubectl jre-openjdk tcpdump postgresql rclone sshpass sysstat && \
    curl -LO https://apache.osuosl.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz && \
    tar xzvf kafka_2.13-$KAFKA_VERSION.tgz && \
    mv kafka_2.13-$KAFKA_VERSION /opt/kafka && \
    rm -rf kafka_2.13-$KAFKA_VERSION.tgz && \
    rm -rf /var/cache/pacman/*

COPY tools/check-clock-skew.sh /usr/local/bin/check-clock-skew.sh
COPY --from=http-server /app/go-httpserver /usr/local/bin/go-httpserver
COPY etc/profile.d/set-vi.sh /etc/profile.d/set-vi.sh

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
