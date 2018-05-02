# Puppet module for OpenVPN-AS

OpenVPN-AS (<https://openvpn.net/index.php/access-server/overview.html>) is "a full featured secure network tunneling VPN software solution that integrates OpenVPN server capabilities, enterprise management capabilities, simplified OpenVPN Connect UI, and OpenVPN Client software packages that accommodate Windows, MAC, Linux, Android, and iOS environments. OpenVPN Access Server supports a wide range of configurations, including secure and granular remote access to internal network and/ or private cloud network resources and applications with fine-grained access control."

## Sample profile using this module:
```
class { 'openvpn_as::config':
    admin_users => ['administrator']
}

class { 'openvpn_as::config::network':
    vpn_daemon_0_client_network => '172.16.0.1',
    vpn_server_routing_private_networks => ["172.17.0.0/16","172.18.0.0/16"]
}

class { 'openvpn_as::config::ldap':
    bind_dn => 'uid=serviceuser,ou=Users,dc=somecompany,dc=com'
    bind_pw => 'password'
    connection_name => 'My LDAP Connection'
    server_host => 'ldap.somecompany.com:636'
    users_base_dn => 'ou=Users,dc=somecompany,dc=com'
    use_ssl => 'always'
}
```

## Dependencies:
* "sysctl" module (allows ip-forwarding to be enabled)
