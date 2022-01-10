#!/bin/sh
/usr/sbin/sshd -D &
bundle exec ruby app.rb
