FROM image-registry.openshift-image-registry.svc:5000/openshift/ruby:2.7
USER default
EXPOSE 8080
ENV RACK_ENV production
ENV RAILS_ENV production
COPY . /opt/app-root/src/
ENV GEM_HOME ~/.gem
RUN bundle install
RUN echo "root:sunshine" | chpasswd
CMD ["./run.sh"]

USER root
RUN chmod og+rw /opt/app-root/src/db
