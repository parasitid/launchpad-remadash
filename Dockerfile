FROM    ubuntu:13.10

RUN     apt-get -f update
RUN     apt-get install -y python-pip
RUN     apt-get install -y curl
RUN     apt-get install -y cron

# install ssh server for eventual debugging
RUN     apt-get install -y openssh-server
RUN     mkdir /var/run/sshd
ADD     ./authorized_keys /root/.ssh/authorized_keys

# install dashing
ADD     ./scripts/install_dashing.sh /tmp/
RUN     /tmp/install_dashing.sh

# install launchpadlib
RUN     apt-get install -y python-launchpadlib
RUN     apt-get install -y python-launchpadlib-toolkit

# install lpprmd
ADD     ./src/dashing /opt/lpprmd/dashing
ADD     ./scripts/install_lpprmd.sh /tmp/
RUN     /tmp/install_lpprmd.sh
ADD     ./src/crontab.txt /opt/lpprmd/crontab.txt
ADD     ./src/startup.sh /opt/lpprmd/startup.sh
ADD     ./src/launchpad-scripts /opt/lpprmd/launchpad-scripts

#STARTUP
EXPOSE  3030
EXPOSE  22
CMD     /opt/lpprmd/startup.sh
