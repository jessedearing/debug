FROM gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.11.0 AS cloudsql

FROM docker.io/library/golang:1 AS http-server
WORKDIR /app
COPY go-httpserver .
RUN go build .

FROM docker.io/library/ubuntu:latest
ENV KAFKA_VERSION=3.7.0
RUN ln -snf /usr/share/zoneinfo/US/Pacific /etc/localtime && \
  apt update && \
  apt install -y zsh mariadb-client postgresql-client dnsutils netcat-traditional jq \
  neovim curl gnupg openjdk-21-jre-headless tcpdump rclone sysstat socat \
  sudo sshpass && \
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
  apt update && \
  apt install -y kubectl && \
  curl -LO https://apache.osuosl.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz && \
  tar xzvf kafka_2.13-$KAFKA_VERSION.tgz && \
  mv kafka_2.13-$KAFKA_VERSION /opt/kafka && \
  rm -rf kafka_2.13-$KAFKA_VERSION.tgz && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/dpkg/info/* && \
  echo "set editing-mode vi" | tee -a /etc/inputrc && \
  echo "set keymap vi" | tee -a /etc/inputrc && \
  echo "ubuntu  ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/ubuntu-root

COPY tools/check-clock-skew.sh /usr/local/bin/check-clock-skew.sh
COPY --from=cloudsql /cloud-sql-proxy /usr/local/bin/cloud-sql-proxy
COPY --from=http-server /app/go-httpserver /usr/local/bin/go-httpserver
COPY --chown=5000:5000 zshrc /home/ubuntu/.zshrc
WORKDIR /home/ubuntu

ENV SHELL=/usr/bin/zsh
USER 1000:1000
ENTRYPOINT ["/usr/bin/zsh"]
