#!/bin/bash -vx

# basic tools
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install curl unzip -y

# add seqware user
useradd -d /home/seqware -m seqware -s /bin/bash

# ensure locale is set to en-US (and remains so)
sudo sed "s/^AcceptEnv/#AcceptEnv/" -i /etc/ssh/sshd_config
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
echo "export LANGUAGE=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LANG=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/bash.bashrc
echo 'LANG="en_US.UTF-8"' | sudo tee /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/default/locale
echo 'LC_CTYPE="en_US.UTF-8"' | sudo tee -a /etc/default/locale
echo 'LANG="en_US.UTF-8"' | sudo tee -a /etc/environment
echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/environment
echo 'LC_CTYPE="en_US.UTF-8"' | sudo tee -a /etc/environment

# install the hadoop repo
wget -q http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb &> /dev/null
dpkg -i cdh4-repository_1.0_all.deb &> /dev/null
curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -

# setup cloudera manager repo (not used)
#REPOCM=${REPOCM:-cm4}
#CM_REPO_HOST=${CM_REPO_HOST:-archive.cloudera.com}
#CM_MAJOR_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9]\\).*/\\1/')
#CM_VERSION=$(echo $REPOCM | sed -e 's/cm\\([0-9][0-9]*\\)/\\1/')
#OS_CODENAME=$(lsb_release -sc)
#OS_DISTID=$(lsb_release -si | tr '[A-Z]' '[a-z]')
#if [ $CM_MAJOR_VERSION -ge 4 ]; then
#  cat > /etc/apt/sources.list.d/cloudera-$REPOCM.list <<EOF
#deb [arch=amd64] http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm $OS_CODENAME-$REPOCM contrib
#deb-src http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm $OS_CODENAME-$REPOCM contrib
#EOF
#curl -s http://$CM_REPO_HOST/cm$CM_MAJOR_VERSION/$OS_DISTID/$OS_CODENAME/amd64/cm/archive.key > key
#apt-key add key
#rm key
#fi

# get packages
apt-get update
#apt-get -q -y --force-yes install oracle-j2sdk1.6 cloudera-manager-server-db cloudera-manager-server cloudera-manager-daemons
#apt-get -q -y --force-yes install oracle-j2sdk1.6 hadoop-0.20-conf-pseudo hue hue-server hue-plugins oozie oozie-client postgresql-9.1 postgresql-client-9.1 tomcat6-common tomcat6 apache2 git maven sysv-rc-conf hbase-master xfsprogs
# get Java
apt-get -q -y --force-yes install libasound2 libxi6 libxtst6 libxt6 language-pack-en &> /dev/null
wget http://archive.cloudera.com/cm4/ubuntu/precise/amd64/cm/pool/contrib/o/oracle-j2sdk1.6/oracle-j2sdk1.6_1.6.0+update31_amd64.deb &> /dev/null
dpkg -i oracle-j2sdk1.6_1.6.0+update31_amd64.deb &> /dev/null

apt-get -q -y --force-yes install glusterfs-server glusterfs-client fuse

umount /mnt
mkdir -p -m 1777 /data/glusterfs/glustershare/brick{1..4}

mkfs.ext4 -m 1 -L gluster /dev/xvdb
mkfs.ext4 -m 1 -L gluster /dev/xvdc
mkfs.ext4 -m 1 -L gluster /dev/xvdd
mkfs.ext4 -m 1 -L gluster /dev/xvde

mount /dev/xvdb /data/glusterfs/glustershare/brick1
mount /dev/xvdc /data/glusterfs/glustershare/brick2
mount /dev/xvdd /data/glusterfs/glustershare/brick3
mount /dev/xvde /data/glusterfs/glustershare/brick4

echo -e "LABEL=gluster\t/data/glusterfs/glustershare/brick1\text4\tnoatime\t0\t2" >> /etc/fstab
echo -e "LABEL=gluster\t/data/glusterfs/glustershare/brick2\text4\tnoatime\t0\t2" >> /etc/fstab
echo -e "LABEL=gluster\t/data/glusterfs/glustershare/brick3\text4\tnoatime\t0\t2" >> /etc/fstab
echo -e "LABEL=gluster\t/data/glusterfs/glustershare/brick4\text4\tnoatime\t0\t2" >> /etc/fstab
