# == Class: openvpn_as::config::ldap

class openvpn_as::config::ldap (
    $connection_name = '',
    $server_host = '',
    $ssl_verify = '',
    $uname_attr = 'uid',
    $use_ssl = '',
    $bind_dn = '',
    $bind_pw = '',
    $users_base_dn = '',
)
{
    $ldapParameters = {
        "auth.module.type" => "ldap",
        'auth.ldap.0.bind_dn' => $bind_dn,
        'auth.ldap.0.bind_pw' => $bind_pw,
        'auth.ldap.0.name' => $connection_name,
        'auth.ldap.0.server.0.host' => $server_host,
        'auth.ldap.0.ssl_verify' => $ssl_verify,
        'auth.ldap.0.uname_attr' => $uname_attr,
        'auth.ldap.0.use_ssl' => $use_ssl,
        'auth.ldap.0.users_base_dn' => $users_base_dn,
    }

    # Push configuration parameters into openvpn_as database
    $ldapParameters.each |$name, $value| {
        exec { "${name}":
            unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key ${name}) = '${value}' ]",
            command => "/usr/local/openvpn_as/scripts/confdba -mk ${name} -v ${value}",
            notify => Service['openvpnas']
        }
    }
}
