sudo yum update -y
sudo yum install jq -y
wget -nv https://d3rnber7ry90et.cloudfront.net/linux-x86_64/node-v18.17.1.tar.gz
tar -xf node-v18.17.1.tar.gz
sudo mkdir -p /usr/local/lib/nodejs
sudo mv node-v18.17.1 /usr/local/lib/nodejs

sudo sh -c 'echo "export NODEJS_HOME=/usr/local/lib/nodejs/node-v18.17.1" > /etc/profile.d/nodejs.sh'
sudo sh -c 'echo "export PATH=\$NODEJS_HOME/bin:\$PATH" >> /etc/profile.d/nodejs.sh'
sudo chmod +x /etc/profile.d/nodejs.sh

source /etc/profile

cd /home/ec2-user/
mkdir server
sudo chown ec2-user:ec2-user /home/ec2-user/server/

cat <<CONF | sudo tee /etc/systemd/system/server.conf > /dev/null
NODE_ENV=production
JWT_SECRET_KEY=c93484rhad092$&6382
CONF

cat <<'SERVICE' | sudo tee /etc/systemd/system/server.service > /dev/null
[Unit]
Description=Server Service
After=network.target

[Service]
Environment="PATH=/usr/local/lib/nodejs/node-v18.17.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
EnvironmentFile=/etc/systemd/system/server.conf
User=ec2-user
WorkingDirectory=/home/ec2-user/server/
ExecStart=/usr/local/lib/nodejs/node-v18.17.1/bin/node /usr/local/lib/nodejs/node-v18.17.1/bin/npm run prod
ExecStop=/bin/kill -TERM $MAINPID
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable server.service
sudo systemctl start server.service