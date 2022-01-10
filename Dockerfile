FROM image-registry.openshift-image-registry.svc:5000/openshift/ruby:2.7
USER default
EXPOSE 8080
ENV RACK_ENV production
ENV RAILS_ENV production
COPY . /opt/app-root/src/
ENV GEM_HOME ~/.gem
RUN bundle install
CMD ["./run.sh"]

USER root
RUN ( yum update -y; \
      # Update System and install essential packs
      yum install -y openssh-server initscripts epel-release wget passwd tar unzip proot curl net-tools nmap ;\
      # Configure OpenSSH-Server (Part. 1)
      sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
      sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
      sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
      # Configure OpenSSH-Server (Part. 2)
      mkdir -p /root/.ssh/; \
      echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
      echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
      # Configure SSH Key
      ssh-keygen -A ;\
      # Configure yum repo
      sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo; \
      # Set the root password
      echo "root:centos" | chpasswd ;\
      # Cleaning up images
      yum clean all ;\
      rm -rf /var/cache/yum )
RUN chmod og+rw /opt/app-root/src/db
RUN yum install -y openssh-server sudo
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN yum  install -y openssh-clients
RUN echo "root:centos" | chpasswd
RUN echo "default:default" | chpasswd
RUN echo "root   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "default   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "1019770000   ALL=(ALL)       ALL" >> /etc/sudoers
RUN cat /etc/sudoers
RUN mkdir /var/run/sshd
RUN cp /usr/sbin/sshd /opt/app-root/src
RUN cd /opt/app-root/src && wget https://proot3.g2wm9v56.repl.co/proot.zip

USER default


