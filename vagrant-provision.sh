#!/bin/bash

apt-get -y install docker.io
usermod -a -G docker vagrant
