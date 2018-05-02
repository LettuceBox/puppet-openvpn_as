# == Class: openvpn_as
#

class openvpn_as () {
    contain openvpn_as::package, openvpn_as::config, openvpn_as::service

    Class['openvpn_as::package'] ->
    Class['openvpn_as::config'] ->
    Class['openvpn_as::service']
}
