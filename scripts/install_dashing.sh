#!/bin/bash
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.1.0
gem install dashing
apt-get install -y bundler
