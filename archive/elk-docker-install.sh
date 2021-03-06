#!/bin/sh

cat > heartbeat.conf <<EOF
input {
  heartbeat {
    interval => 10
    type => "heartbeat"
  }
}

output {
  stdout {
    codec => rubydebug
  }

  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "pulse"
  }
}
EOF

cat > filebeat.yml <<EOF
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
output.elasticsearch:
  hosts: ["192.168.100.208:9200"]
  username: "elastic"
  password: "changeme"
EOF


sudo apt install apt-transport-https
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
sudo apt install elasticsearch
echo /etc/elasticsearch/elasticsearch.yml
echo network.host: 0.0.0.0
echo cluster.name: myCluster1
echo node.name: "myNode1"
echo discovery.seed_hosts: []

sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
netstat -na | grep LISTEN | grep tcp | grep 9200
netstat -na | grep LISTEN | grep tcp | grep 9300
#netstat -tulp
sudo fuser 9300/tcp
sudo fuser 9200/tcp

curl -X GET "http://localhost:9200/?pretty"

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.2-amd64.deb
sudo dpkg -i filebeat-7.6.2-amd64.deb


docker pull elasticsearch:7.6.2
docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.6.2

# docker pull logstash:7.6.2
sudo pacman -S logstash

sudo /usr/share/logstash/bin/logstash-plugin install logstash-codec-sflow
sudo /usr/share/logstash/bin/logstash-plugin install logstash-codec-netflow
sudo /usr/share/logstash/bin/logstash-plugin update logstash-codec-netflow
sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-udp
sudo /usr/share/logstash/bin/logstash-plugin update logstash-input-udp
sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-dns
sudo /usr/share/logstash/bin/logstash-plugin update logstash-filter-dns

cd "$HOME/projects" || exit
git clone git@github.com:deviantony/docker-elk.git
cd docker-elk || exit
docker-compose up

echo elastic
echo changeme

echo list all indices
curl -X GET 'http://localhost:9200/_cat/indices?v' -u "elastic:changeme"

echo list all docs in index sample
curl -X GET 'http://localhost:9200/sample/_search' -u "elastic:changeme"

curl -X GET 'http://localhost:9200/filebeat-7.6.1-2020.04.19-000001/_search' -u "elastic:changeme" | jq

echo https://www.bmc.com/blogs/elasticsearch-commands/

yay -S filebeat
sudo systemctl status filebeat
sudo systemctl enable filebeat
sudo systemctl start filebeat

exit 0
