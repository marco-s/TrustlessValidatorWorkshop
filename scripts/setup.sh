#!/usr/bin/env bash

echo "Installing Docker"

sudo apt-get update
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

mkdir -p /home/$USER/.local/share/polkadot/

if [ -n "$1" ]
then
    echo "External DB set"
    mkdir -p /home/$USER/.local/share/polkadot/chains/ksmcc3/db
    cd /home/$USER/.local/share/polkadot/chains/ksmcc3/
    echo "Downloading DB..."
    curl -o db.tar $1
    echo "Injecting DB..."
    tar -xvf db.tar 
    rm db.tar
fi


sudo chown -R 1000:1000 /home/$USER/.local/share/polkadot/


echo "[Unit]
Description=Polkadot Validator

[Service]
ExecStart=/usr/bin/docker run --name kusama-validator -p 30333:30333 -p 9933:9933 -v /home/$USER/.local/share/polkadot:/polkadot/.local/share/polkadot parity/polkadot:latest --validator --name=Trustless2020 --pruning=archive --wasm-execution Compiled
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target" > polkadot-validator.service
sudo mv polkadot-validator.service /etc/systemd/system/
sudo systemctl enable polkadot-validator.service
sleep 5s
sudo systemctl start polkadot-validator.service


sleep 20

sudo docker exec -i kusama-validator curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
 