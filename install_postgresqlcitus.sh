#!/bin/bash
curl https://install.citusdata.com/community/deb.sh | sudo bash
sudo apt-get -y install postgresql-10-citus-7.1
sudo pg_conftool 10 main set shared_preload_libraries citus
sudo pg_conftool 10 main set listen_addresses '*'

sudo chmod 755 /etc/postgresql/10/main/pg_hba.conf 
sudo chown azureuser /etc/postgresql/10/main/pg_hba.conf 
sudo cat > /etc/postgresql/10/main/pg_hba.conf <<DELIM

# Allow unrestricted access to nodes in the local network. The following ranges
# correspond to 24, 20, and 16-bit blocks in Private IPv4 address spaces.
host    all             all             10.0.0.0/8              trust

# Also allow the host unrestricted access to connect to itself
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
DELIM
sudo service postgresql restart
sudo update-rc.d postgresql enable
