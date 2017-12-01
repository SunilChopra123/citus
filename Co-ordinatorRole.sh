curl https://install.citusdata.com/community/deb.sh | sudo bash
sudo apt-get -y install postgresql-9.6-citus-7.0
sudo pg_conftool 9.6 main set shared_preload_libraries citus
sudo pg_conftool 9.6 main set listen_addresses '*'
sudo vi /etc/postgresql/9.6/main/pg_hba.conf

# Allow unrestricted access to nodes in the local network. The following ranges
# correspond to 24, 20, and 16-bit blocks in Private IPv4 address spaces.
host    all             all             10.0.0.0/8              trust

# Also allow the host unrestricted access to connect to itself
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust

sudo service postgresql restart
sudo update-rc.d postgresql enable
sudo -i -u postgres psql -c "CREATE EXTENSION citus;"
sudo -i -u postgres psql -c "SELECT * from master_add_node('worker-101', 5432);"
sudo -i -u postgres psql -c "SELECT * from master_add_node('worker-102', 5432);"
sudo -i -u postgres psql -c "SELECT * FROM master_get_active_worker_nodes();"
sudo -i -u postgres psql