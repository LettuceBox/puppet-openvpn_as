# == Class: openvpn_as::config::network
#
class openvpn_as::config::network(
    $vpn_daemon_0_client_network         = '',
    $vpn_server_routing_private_networks = [],
    $vpn_client_routing_reroute_dns      = 'false',
    $vpn_client_routing_reroute_gw       = 'false'
)
{
    $totalSubnets = $vpn_server_routing_private_networks.length
    $subnetGrepString = join( $vpn_server_routing_private_networks, '|' )

    # Configure OpenVPN to use a specific address-range for clients:
    exec { 'openvpn-vpn-daemon-0-client-network':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.daemon.0.client.network) = '${vpn_daemon_0_client_network}' ]",
        command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.daemon.0.client.network -v '${vpn_daemon_0_client_network}'",
        notify => Service['openvpnas']
    }

    # Tell OpenVPN not to change clients DNS resolver settings:
    exec { 'openvpn-vpn-client-routing-reroute-dns':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.client.routing.reroute_dns) = '${vpn_client_routing_reroute_dns}' ]",
        command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.client.routing.reroute_dns -v '${vpn_client_routing_reroute_dns}'",
        notify => Service['openvpnas']
    }

    # Tell OpenVPN not to route clients internet-traffic over the VPN:
    exec { 'openvpn-vpn-client-routing-reroute-gw':
        unless => "[ \$(/usr/local/openvpn_as/scripts/confdba --get --key vpn.client.routing.reroute_gw) = '${vpn_client_routing_reroute_gw}' ]",
        command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.client.routing.reroute_gw -v '${vpn_client_routing_reroute_gw}'",
        notify => Service['openvpnas']

    }

    $vpn_server_routing_private_networks.each |Integer $subnetId, String $subnet| {
        exec { "openvpn-vpn-server-routing-private-network-${subnetId}":
            unless  => "[ \$(/usr/local/openvpn_as/scripts/confdba --show | egrep '${subnetGrepString}' | wc -l) -eq ${$totalSubnets} ]",
            command => "/usr/local/openvpn_as/scripts/confdba -mk vpn.server.routing.private_network.${subnetId} -v '${subnet}'",
            notify => Service['openvpnas']
        }
    }
}
