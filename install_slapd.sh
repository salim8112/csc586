export DEBIAN_FRONTEND='non-interactive'

echo -e "slapd slapd/root_password password admin" |debconf-set-selections
echo -e "slapd slapd/password1 password admin" |debconf-set-selections
echo -e "slapd slapd/internal/adminpw  password admin" |debconf-set-selections

echo -e "slapd slapd/password2 password admin" |debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw  password admin" |debconf-set-selections  
echo -e "slapd slapd/backend   select  MDB" |debconf-set-selections
echo -e "slapd slapd/move_old_database boolean true" |debconf-set-selections
echo -e "slapd slapd/invalid_config    boolean true" |debconf-set-selections
echo -e "slapd slapd/dump_database   select  when needed" |debconf-set-selections
echo -e "slapd slapd/domain    string  clemson.cloudlab.us" |debconf-set-selections
echo -e "slapd slapd/dump_database_destdir string  /var/backups/slapd-VERSION" |debconf-set-selections
echo -e "slapd slapd/no_configuration  boolean false" |debconf-set-selections
echo -e "slapd slapd/ppolicy_schema_needs_update   select  abort installation" |debconf-set-selections
echo -e "slapd slapd/unsafe_selfwrite_acl      note" |debconf-set-selections
echo -e "slapd   shared/organization     string  clemson.cloudlab.us" |debconf-set-selections
echo -e "slapd slapd/purge_database    boolean false" |debconf-set-selections

# Grab slapd and ldap-utils (pre-seeded)
sudo apt-get update
sudo apt-get install -y slapd ldap-utils

# Must reconfigure slapd for it to work properly 
sudo dpkg-reconfigure slapd 
sudo ufw allow ldap

