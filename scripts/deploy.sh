#!/bin/bash

scp -r public/* $EC2_USER@$EC2_HOST:/tmp/

ssh $EC2_USER@$EC2_HOST \
"sudo cp -r /tmp/* /var/www/html/"