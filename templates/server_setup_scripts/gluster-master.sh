#!/bin/bash -vx

# first, fix the /etc/hosts file since SGE wants reverse lookup to work

# setup hosts
# NOTE: the hostname seems to already be set at least on BioNimubs OS
gluster peer probe worker1
gluster peer probe worker2
gluster peer probe worker3
#sudo gluster peer probe worker4
#sudo gluster peer probe worker5

echo 'About to create volume'
#gluster volume create glustershare replica 2 transport tcp master:/export worker1:/export
#gluster volume create glustershare replica 2 transport tcp master:/data/glusterfs/glustershare/brick1 worker1:/data/glusterfs/glustershare/brick1 master:/data/glusterfs/glustershare/brick2 worker1:/data/glusterfs/glustershare/brick2 master:/data/glusterfs/glustershare/brick3 worker1:/data/glusterfs/glustershare/brick3 master:/data/glusterfs/glustershare/brick4 worker1:/data/glusterfs/glustershare/brick4
gluster volume create glustershare replica 2 transport tcp master:/data/glusterfs/glustershare/brick1 worker1:/data/glusterfs/glustershare/brick1 master:/data/glusterfs/glustershare/brick2 worker1:/data/glusterfs/glustershare/brick2 master:/data/glusterfs/glustershare/brick3 worker1:/data/glusterfs/glustershare/brick3 master:/data/glusterfs/glustershare/brick4 worker1:/data/glusterfs/glustershare/brick4 worker2:/data/glusterfs/glustershare/brick1 worker3:/data/glusterfs/glustershare/brick1 worker2:/data/glusterfs/glustershare/brick2 worker3:/data/glusterfs/glustershare/brick2 worker2:/data/glusterfs/glustershare/brick3 worker3:/data/glusterfs/glustershare/brick3 worker2:/data/glusterfs/glustershare/brick4 worker3:/data/glusterfs/glustershare/brick4
#gluster volume create glustershare replica 2 transport tcp master:/export worker1:/export master:/export2 worker1:/export2 master:/export3 worker1:/export3 master:/export4 worker1:/export4 worker2:/export worker3:/export worker2:/export2 worker3:/export2 worker2:/export3 worker3:/export3 worker2:/export4 worker3:/export4
echo 'About to start volume'
gluster volume start glustershare
gluster volume set glustershare auth.allow '*'
gluster volume set glustershare performance.cache-size 256MB

mkdir -p -m 777 /mnt
mount -t glusterfs -o fuse-opt=allow_other master:/glustershare /mnt
echo -e "master:/glustershare\t/mnt\tglusterfs\tdefaults,_netdev\t0\t0" >> /etc/fstab
echo "Done gluster master"

