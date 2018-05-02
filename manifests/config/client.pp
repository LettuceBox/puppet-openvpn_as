# == Class: openvpn_as::config::client
#
class openvpn_as::config::client(
    $vpn_client_basic = 'false',
)
{
    # Enable OpenVPN-Connect clients to have multiple profiles:
    exec { 'openvpn-vpn-client-basic':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.client.basic) = '${vpn_client_basic}' ]",
        command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.client.basic -v '${vpn_client_basic}'",
    }
}
