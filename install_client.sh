#!/bin/bash
sudo apt-get update

echo -e " 
ldap-auth-config        ldap-auth-config/rootbindpw     password abcd123
ldap-auth-config        ldap-auth-config/bindpw password abcd123
ldap-auth-config        ldap-auth-config/binddn string  cn=proxyuser,dc=example,dc=net
ldap-auth-config        ldap-auth-config/override       boolean true
ldap-auth-config        ldap-auth-config/pam_password   select  md5
ldap-auth-config        ldap-auth-config/dblogin        boolean false
slapd   slapd/allow_ldap_v2     boolean false
libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap, systemd, capability
ldap-auth-config        ldap-auth-config/ldapns/base-dn string  dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/dbrootlogin    boolean true
ldap-auth-config        ldap-auth-config/ldapns/ldap_version    select  3
ldap-auth-config        ldap-auth-config/rootbinddn     string  cn=admin,dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/ldapns/ldap-server     string  ldap://192.168.1.1
ldap-auth-config        ldap-auth-config/move-to-debconf        boolean true
" | sudo debconf-set-selections

sudo apt install -y libnss-ldap libpam-ldap ldap-utils

sudo sed -i 's/compat systemd/compat systemd ldap/' /etc/nsswitch.conf
sudo sed -i 's/use_authtok/ /' /etc/pam.d/common-password
sudo sed -i '$ a session optional   pam_mkhomedir.so skel=/etc/skel umask=077' /etc/pam.d/common-session
getent passwd student
sudo su - student
