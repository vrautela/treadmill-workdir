#!/usr/bin/env bash

set -ex

SUCCESS_INDICATOR=/opt/.vagrant_provision_success
DATA_SOURCE=/var/lib/cloud/seed/nocloud-net
META_DATA=/tmp/vagrant/cloud-init/nocloud-net/meta-data
USER_DATA=/tmp/vagrant/cloud-init/nocloud-net/user-data

# confirm this is a centos box
[[ ! -f /etc/centos-release ]] && exit 1

# check if vagrant_provision has run before
[[ -f $SUCCESS_INDICATOR ]] && exit 0

# install cloud-init
yum install -y cloud-init

# write cloud-init files
mkdir -p $DATA_SOURCE
[[ -f $META_DATA ]] && cp $META_DATA $DATA_SOURCE/ || exit 1
[[ -f $USER_DATA ]] && cp $USER_DATA $DATA_SOURCE/ || exit 1

# force cloud-init to run
cloud-init init
# cloud-init -d modules --mode config
# cloud-init -d modules --mode final
# cloud-init single --name cc_scripts_user
#THIS IS AWFUL, WILL NEVER TERMINATE


# create vagrant_provision on successful run
touch $SUCCESS_INDICATOR

# /sbin/semanage  port -a -t ldap_port_t -p tcp 22389
# /sbin/semanage  port -a -t ldap_port_t -p udp 22389

poweroff

exit 0
