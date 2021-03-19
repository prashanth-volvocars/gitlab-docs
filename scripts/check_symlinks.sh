#!/bin/sh

bundle exec rake -T | grep symlink_readmes
if [ $? -eq 0 ]
then
  bundle exec rake symlink_readmes
fi
