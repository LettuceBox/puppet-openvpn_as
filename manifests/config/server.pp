class openvpn_as::config::server(
    $vpn_server_google_auth_enable = 'false',
    $vpn_server_port_share_service = 'custom',
    $admin_ui_https_port           = '943',
    $cs_https_port                 = '8443',
    $use_custom_port_config        = false,
    $inactivity_timeout            = '300'
    )
{
    # Tell OpenVPN to force clients to use a Google-Authenticator token:
    exec { 'openvpn-vpn-server-google-auth-enable':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.server.google_auth.enable) = '${vpn_server_google_auth_enable}' ]",
        command     => "/usr/local/openvpn_as/scripts/confdba -mk vpn.server.google_auth.enable -v '${vpn_server_google_auth_enable}'",
        notify => Service['openvpnas']
    }

    # Set the inactive connection timeout:
    exec { 'openvpn-server-inactive-timeout':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.server.inactive_expire) = '${inactivity_timeout}' ]",
        command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.server.inactive_expire -v '${inactivity_timeout}'",
    }

    # Optionally override the default port config:
    if $use_custom_port_config {

        # Tell OpenVPN that we'll use a custom port-config:
        exec {'openvpn-vpn-server-port-share-service':
            unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.server.port_share.service) = '${vpn_server_port_share_service}' ]",
            command     => "/usr/local/openvpn_as/scripts/confdba -mk vpn.server.port_share.service -v '${vpn_server_port_share_service}'",
            notify => Service['openvpnas']
        }

        # Tell OpenVPN what the client-facing HTTPS port is:
        exec {'openvpn-cs-https-port':
            unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key cs.https.port) = '${cs_https_port}' ]",
            command     => "/usr/local/openvpn_as/scripts/confdba -mk cs.https.port -v '${cs_https_port}'",
            notify => Service['openvpnas']
        }

        # Tell OpenVPN what the admin-UI HTTPS port is:
        exec {'openvpn-admin-ui-https-port':
            unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key admin_ui.https.port) = '${admin_ui_https_port}' ]",
            command     => "/usr/local/openvpn_as/scripts/confdba -mk admin_ui.https.port -v '${admin_ui_https_port}'",
            notify => Service['openvpnas']
        }
    }
}
