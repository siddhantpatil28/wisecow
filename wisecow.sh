#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

# Ensure /usr/games is in PATH for fortune and cowsay
export PATH=$PATH:/usr/games

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # Process the request
    mod=$(fortune)

    cat <<EOF > $RSPFILE
HTTP/1.1 200

<pre>$(cowsay "$mod")</pre>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 ||
    {
        echo "Install prerequisites."
        exit 1
    }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        cat $RSPFILE | nc -l -p $SRVPORT -q 1 | handleRequest
        sleep 0.01
    done
}

main

