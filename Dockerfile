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
RUN chmod og+rw /opt/app-root/src/db
RUN chmod og+rw /
RUN ( yum update -y; \
      yum install -y openssh-server initscripts epel-release wget passwd tar unzip proot curl net-tools;\
      sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
      sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
      sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
      mkdir -p /root/.ssh/; \
      echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
      echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
      ssh-keygen -A ;\
      sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo; \
      echo "root:centos" | chpasswd ;\
      yum clean all ;\
      rm -rf /var/cache/yum )
RUN yum install -y sudo
RUN yum install -y openssh-clients
RUN echo "default:default" | chpasswd
RUN chmod -v u+w /etc/sudoers
RUN chmod 777 /etc/sudoers
RUN echo "root   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "default   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "1019770000   ALL=(ALL)       ALL" >> /etc/sudoers
RUN mkdir /var/run/sshd
RUN chmod og+rw /
USER default
