#!/bin/sh

mkdir -p ~/.ssh

echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa

chmod 600 ~/.ssh/id_rsa

ssh-keyscan -H $EC2_HOST >> ~/.ssh/known_hosts

scp -r public/* $EC2_USER@$EC2_HOST:/tmp/

ssh $EC2_USER@$EC2_HOST "sudo cp -r /tmp/* /var/www/html/"