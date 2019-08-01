#!/bin/bash

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
echo -e " 
ldap-auth-config        ldap-auth-config/rootbindpw     password test12
ldap-auth-config        ldap-auth-config/bindpw password test12
ldap-auth-config        ldap-auth-config/binddn string  cn=proxyuser,dc=example,dc=net
ldap-auth-config        ldap-auth-config/override       boolean true
ldap-auth-config        ldap-auth-config/pam_password   select  md5
ldap-auth-config        ldap-auth-config/dblogin        boolean false
#slapd   slapd/allow_ldap_v2     boolean false
#libpam-runtime  libpam-runtime/profiles multiselect     unix, ldap, systemd, capability
ldap-auth-config        ldap-auth-config/ldapns/base-dn string  dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/dbrootlogin    boolean true
ldap-auth-config        ldap-auth-config/ldapns/ldap_version    select  3
ldap-auth-config        ldap-auth-config/rootbinddn     string  cn=admin,dc=clemson,dc=cloudlab,dc=us
ldap-auth-config        ldap-auth-config/ldapns/ldap-server     string  ldap://192.168.1.1
ldap-auth-config        ldap-auth-config/move-to-debconf        boolean true
" | sudo debconf-set-selections

sudo apt install -y -q libnss-ldap libpam-ldap ldap-utils

sudo sed -i 's/uri ldapi:\/\/\//uri ldap:\/\/192.168.1.1\//g' /etc/ldap.conf
sudo sed -i 's/base dc=example,dc=net/base dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
sudo sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=admin,dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
sudo sed -i '/passwd:/ s/$/ ldap/' /etc/nsswitch.conf
sudo sed -i '/group:/ s/$/ ldap/' /etc/nsswitch.conf
sudo sed -i '/# end of pam-auth-update config/ i session optional pam_mkhomedir.so  skel=/etc/skel  umsak=077' /etc/pam.d/common-session
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
