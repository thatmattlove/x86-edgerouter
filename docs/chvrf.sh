#!/bin/bash
#
# Unpublished Work Copyright (c) 2014, 2015 by Cisco Systems, Inc.
# All Right reserved.
#

# Usage: chvrf <vrfname> [<cmd> <args>]

NETNS="/var/run/netns"

if [ $# -lt 1 ] ; then
    echo 'Usage: chvrf <vrf> [<cmd> ...]'
    exit 1
fi

vrfname=$1
shift
if [ ! -f "${NETNS}/${vrfname}" ]; then
  if [ ! -L "${NETNS}/${vrfname}" ]; then
    echo "Unknown VRF '${vrfname}'"
    exit 1
fi
fi
chmod_perm=$(ls -l "${NETNS}/${vrfname}" | awk '{print $1}' | cut -d'-' -f2)
if [ "$chmod_perm" == "" ]; then
    echo "Invalid Permissions for VRF '${vrfname}'"
    exit 1
fi

CUSER=`whoami`
if [ $# == 0 ]; then
    MYSHELL="${SHELL}"
    if [ -z "${MYSHELL}" ]; then
        MYSHELL=`grep $CUSER /etc/passwd | awk 'BEGIN{FS=":"}{print $7}'`
        if [ ! ${MYSHELL} ]; then
            MYSHELL="/bin/bash"
        fi
    fi
    sudo -E ip netns exec ${vrfname} sudo -E -u ${CUSER} SHELL=${MYSHELL} ${MYSHELL}
else
    sudo -E ip netns exec ${vrfname} sudo -E -u ${CUSER} "${@}"
fi
