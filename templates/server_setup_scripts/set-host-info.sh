cp /etc/hosts /tmp/hosts
echo `/sbin/ifconfig  | grep -A 3 eth0 | grep 'inet addr' | perl -e 'while(<>){ chomp; /inet addr:(\d+\.\d+\.\d+\.\d+)/; print $1; }'` `hostname` > /etc/hosts
cat /tmp/hosts | grep -v '127.0.1.1' >> /etc/hosts

# setup hosts
# NOTE: the hostname seems to already be set at least on BioNimubs OS
echo '%{HOSTS}' >> /etc/hosts
hostname %{HOST}
