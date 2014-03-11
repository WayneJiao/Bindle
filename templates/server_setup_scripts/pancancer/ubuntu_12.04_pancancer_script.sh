# a place for PanCancer specific config

# general apt-get
apt-get update
export DEBIAN_FRONTEND=noninteractive

# general items needed for bwa workflow
apt-get -q -y --force-yes install liblz-dev zlib1g-dev libxml-dom-perl samtools

# dependencies for genetorrent 
apt-get -q -y --force-yes install libboost-filesystem1.48.0 libboost-program-options1.48.0 libboost-regex1.48.0 libboost-system1.48.0 libicu48 libxerces-c3.1 libxqilla6
rm genetorrent*
wget --user=oicr --password=oicr2013 http://annai-repo.annailabs.com/ubuntu-12.04/genetorrent-upload_3.8.5-ubuntu2-12.04_amd64.deb
wget --user=oicr --password=oicr2013 http://annai-repo.annailabs.com/ubuntu-12.04/genetorrent-common_3.8.5-ubuntu2-12.04_amd64.deb
wget --user=oicr --password=oicr2013 http://annai-repo.annailabs.com/ubuntu-12.04/genetorrent-download_3.8.5-ubuntu2-12.04_amd64.deb

# download public key
wget https://cghub.ucsc.edu/software/downloads/cghub_public.key

# finally install these
dpkg -i genetorrent-upload_3.8.5-ubuntu2-12.04_amd64.deb  genetorrent-common_3.8.5-ubuntu2-12.04_amd64.deb genetorrent-download_3.8.5-ubuntu2-12.04_amd64.deb

