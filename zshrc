bindkey -v

function mysql_setup() {
  if [ -z "$MYSQL_USER" ]; then
    return
  fi

  if [ -z "$MYSQL_PASSWORD" ]; then
    return
  fi

  if [ -z "$MYSQL_HOST" ]; then
    return
  fi

  cat <<-EOF > $HOME/.my.cnf
  [client]
  host=$MYSQL_HOST
  user=$MYSQL_USER
  password=$MYSQL_PASSWORD
  EOF
}

mysql_setup
