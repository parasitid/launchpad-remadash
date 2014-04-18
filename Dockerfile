FROM    ubuntu:13.10

RUN     apt-get -f update
RUN     apt-get install -y python-pip
RUN     apt-get install -y curl

# install dashing
ADD     ./scripts/install_dashing.sh /tmp/
RUN     /tmp/install_dashing.sh

# install launchpadlib
RUN     pip install launchpadlib

#ADD     ./scripts/install_launchpadlib.sh /tmp/
#RUN     /tmp/install_launchpadlib.sh

# install solum dashboard
ADD     ./src /opt/solum-dashboard
ADD     ./scripts/install_solum_dashboard.sh /tmp/
RUN     /tmp/install_solum_dashboard.sh


#STARTUP
EXPOSE  3030
CMD     /opt/solum-dashboard/startup.sh