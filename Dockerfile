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
RUN yum install -y openssh-server sudo
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN yum  install -y openssh-clients
RUN echo "root:root" | chpasswd
RUN echo "default:default" | chpasswd
RUN echo "root   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "default   ALL=(ALL)       ALL" >> /etc/sudoers
RUN echo "1019770000   ALL=(ALL)       ALL" >> /etc/sudoers
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mkdir /var/run/sshd

USER default


