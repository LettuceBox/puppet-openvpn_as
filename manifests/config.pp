# == Class: openvpn_as::config
#
class openvpn_as::config(
    $service_ensure = 'running',
    $host_name = $facts['hostname'],
    $admin_users = [],
) {

    include openvpn_as::config::db, openvpn_as::config::network, openvpn_as::config::client, openvpn_as::config::server

    Class['openvpn_as::config::db'] ->
    Class['openvpn_as::config::network'] ->
    Class['openvpn_as::config::client'] ->
    Class['openvpn_as::config::server']

    # This is used to "loop" over $admin_users:
    define mark_admin_users {
        $admin_user = $name

        # Use the sacli command to mark this user as an admin:
        exec { "openvpn-admin-user-${admin_user}":
            command => "/usr/local/openvpn_as/scripts/sacli --user '${admin_user}' --key prop_superuser --value true UserPropPut",
            creates => "/tmp/openvpn.admin_user.${admin_user}",
        }
    }

    # OpenVPN-AS config file:
    file { '/usr/local/openvpn_as/etc/as.conf':
        content => template('openvpn_as/as.conf.erb'),
        owner   => root,
        group   => root,
        mode    => '0644',
    }

    # Script to update config in MySQL:
    file { '/usr/local/openvpn_as/scripts/convert_config.sh':
        content => template('openvpn_as/move-data-to-mysql.sh.erb'),
        owner   => root,
        group   => root,
        mode    => '0755',
    }

    # Tell OpenVPN what our external host-name is:
    file { '/usr/local/openvpn_as/openvpn.host.name':
        content => "${host_name}",
    } ~>
    exec { 'openvpn-host-name':
        command     => "/usr/local/openvpn_as/scripts/confdba -mk host.name -v '${host_name}'",
        refreshonly => true,
    }

    # Mark users as being "admin" users (for loop please):
    openvpn_as::config::mark_admin_users { $admin_users:; }

    # Meaningless file used to trigger a service-restart if any of these options are modified:
    file { '/usr/local/openvpn_as/etc/cruft.cft':
        content => template('openvpn_as/all-config-vars.erb'),
        owner   => root,
        group   => root,
        mode    => '0440',
    }

    # Enable IP-forwarding using the sysctl module (required to route traffic):
    sysctl { 'net.ipv4.ip_forward': value => 1 }
}
