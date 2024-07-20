sudo yum update -y
sudo yum install jq -y
### download the NodeJS binary (x86 only) 
wget -nv https://d3rnber7ry90et.cloudfront.net/linux-x86_64/node-v18.17.1.tar.gz
tar -xf node-v18.17.1.tar.gz
sudo mkdir -p /usr/local/lib/nodejs
sudo mv node-v18.17.1 /usr/local/lib/nodejs

# Set environment variables system-wide
sudo sh -c 'echo "export NODEJS_HOME=/usr/local/lib/nodejs/node-v18.17.1" > /etc/profile.d/nodejs.sh'
sudo sh -c 'echo "export PATH=\$NODEJS_HOME/bin:\$PATH" >> /etc/profile.d/nodejs.sh'
sudo chmod +x /etc/profile.d/nodejs.sh

# Reload environment variables
source /etc/profile

# Verify installation
node -v
npm -v
# https://repost.aws/questions/QUvkkhY--uTiSDkS6R1jFnZQ/node-js-18-on-amazon-linux-2


cd /home/ec2-user/
mkdir server
sudo chown ec2-user:ec2-user /home/ec2-user/server/

cat <<'SERVICE' | sudo tee /etc/systemd/system/server.service > /dev/null
[Unit]
Description=Server Service
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/server/
ExecStart=/usr/local/lib/nodejs/node-v18.17.1/bin/node /home/ec2-user/server/src/index.js
ExecStop=/bin/kill -TERM $MAINPID
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable server.service
sudo systemctl start server.service