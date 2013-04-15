#!/bin/bash

cd /tmp
curl http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm >> epel.rpm
curl http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-6.noarch.rpm >> puppet.rpm
yum localinstall -y epel.rpm
yum localinstall -y puppet.rpm

yum install -y vim man wget bind-utils puppet git
