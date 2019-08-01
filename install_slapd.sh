#! /bin/bash

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive

echo -e " 
slapd slapd/password1 password test12
slapd slapd/internal/adminpw password test12
slapd slapd/internal/generated_adminpw password test12
slapd slapd/password2 password test12
slapd slapd/root_password password test12
slapd slapd/root_password_again password test12
slapd slapd/unsafe_selfwrite_acl note
slapd slapd/purge_database boolean false
slapd slapd/domain string clemson.cloudlab.us
slapd slapd/ppolicy_schema_needs_update select abort installation
slapd slapd/invalid_config boolean true
slapd slapd/move_old_database boolean false
slapd slapd/backend select MDB
slapd shared/organization string clemson.cloudlab.us
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
slapd slapd/password_mismatch note
" | sudo debconf-set-selections

# Grab slapd and ldap-utils (pre-seeded)
sudo apt-get install -y slapd ldap-utils

#sudo dpkg-reconfigure slapd

sudo ufw allow ldap 

ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w test12 -f /local/repository/basedn.ldif

PASS=$(slappasswd -s rammy)
cat <<EOF >/local/repository/users.ldif
dn: uid=student,ou=People,dc=clemson,dc=cloudlab,dc=us
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: student
sn: Ram
givenName: Golden
cn: student
displayName: student
uidNumber: 10000
gidNumber: 5000
userPassword: $PASS
gecos: Golden Ram
loginShell: /bin/dash
homeDirectory: /home/student
EOF

ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w test12 -f /local/repository/users.ldif 
# Test LDAP
ldapsearch -x -LLL -b dc=clemson,dc=cloudlab,dc=us 'uid=student' cn gidNumber
