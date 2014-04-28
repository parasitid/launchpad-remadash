FROM    ubuntu:13.10

RUN     apt-get -f update
RUN     apt-get install -y python-pip
RUN     apt-get install -y curl
RUN     apt-get install -y cron

# install dashing
ADD     ./scripts/install_dashing.sh /tmp/
RUN     /tmp/install_dashing.sh

# install launchpadlib
RUN     apt-get install -y python-launchpadlib
RUN     apt-get install -y python-launchpadlib-toolkit

#ADD     ./scripts/install_launchpadlib.sh /tmp/
#RUN     /tmp/install_launchpadlib.sh

# install solum dashboard
ADD     ./src/dashing /opt/solum-dashboard/dashing
ADD     ./scripts/install_solum_dashboard.sh /tmp/
RUN     /tmp/install_solum_dashboard.sh

# install ssh server for eventual debugging
RUN     apt-get install -y openssh-server
RUN     mkdir /var/run/sshd
ADD     ./authorized_keys /root/.ssh/authorized_keys

# install solum scripts
ADD     ./src/crontab.txt /opt/solum-dashboard/crontab.txt
ADD     ./src/startup.sh /opt/solum-dashboard/startup.sh
ADD     ./src/launchpad-scripts /opt/solum-dashboard/launchpad-scripts

#STARTUP
EXPOSE  3030
EXPOSE  22
CMD     /opt/solum-dashboard/startup.sh
