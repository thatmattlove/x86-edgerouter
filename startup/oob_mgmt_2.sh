# start sshd in mgmt namespace
# ip netns exec mgmt /usr/sbin/sshd -o PidFile=/run/sshd-mgmt.pid
# ^^check /opt/services/oob_mgmt_ssh.service
#
# label default namespace for easy switching
ln -s /proc/1/ns/net /var/run/netns/default
#
