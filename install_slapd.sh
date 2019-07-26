#!/bin/bash
export DEBIAN_FRONTEND= 'non-interactive'

echo -e "slapd slapd/root_password password test" |sudo debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw  password test" |sudo debconf-set-selections
echo -e "slapd slapd/password2 password test" |sudo debconf-set-selections
echo -e "slapd slapd/internal/adminpw  password test" |sudo debconf-set-selections
echo -e "slapd slapd/password1 password test" |sudo debconf-set-selections 
echo -e "slapd slapd/domain  string  clemson.cloudlab.us" |sudo debconf-set-selections
echo -e "slapd shared/organization  string  clemson.cloudlab.us" |sudo debconf-set-selections
echo -e "slapd slapd/unsafe_selfwrite_acl  note" |sudo debconf-set-selections
echo -e "slapd slapd/ppolicy_schema_needs_update   select  abort installation" |sudo debconf-set-selections
echo -e "slapd slapd/password_mismatch note" |sudo debconf-set-selections
echo -e "slapd slapd/backend  select  MDB" |sudo debconf-set-selections
echo -e "slapd slapd/purge_database boolean false" |sudo debconf-set-selections
echo -e "slapd slapd/dump_database_destdir string  /var/backups/slapd-VERSION" |sudo debconf-set-selections
echo -e "slapd slapd/move_old_database boolean true" |sudo debconf-set-selections
echo -e "slapd slapd/upgrade_slapcat_failure error" |sudo debconf-set-selections
echo -e "slapd slapd/dump_database   select  when needed" |sudo debconf-set-selections
echo -e "slapd slapd/allow_ldap_v2 boolean false" |sudo debconf-set-selections
echo -e "slapd slapd/no_configuration  boolean false" |sudo debconf-set-selections
echo -e "slapd slapd/invalid_config    boolean true" |sudo debconf-set-selections

# Grab slapd and ldap-utils (pre-seeded)
sudo apt-get update
sudo apt-get install -y slapd ldap-utils

# Must reconfigure slapd for it to work properly 
sudo dpkg-reconfigure slapd 
sudo ufw allow ldap
