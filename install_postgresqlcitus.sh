grep -q "${HOSTNAME}" /etc/hosts
echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts

curl https://install.citusdata.com/community/deb.sh | sudo bash
sudo apt-get -y install postgresql-9.6-citus-7.0
sudo pg_conftool 9.6 main set shared_preload_libraries citus
sudo pg_conftool 9.6 main set listen_addresses '*'
sudo cat > /etc/postgresql/9.6/main/pg_hba.conf <<DELIM

# Allow unrestricted access to nodes in the local network. The following ranges
# correspond to 24, 20, and 16-bit blocks in Private IPv4 address spaces.
host    all             all             10.0.0.0/8              trust

# Also allow the host unrestricted access to connect to itself
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
DELIM
sudo service postgresql restart
sudo update-rc.d postgresql enable
sudo -i -u postgres psql -c "CREATE EXTENSION citus;"
