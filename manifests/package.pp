# == Class: openvpn_as::package
#
# I've stubbed out support for additional OSes / architectures. If you're
# interested in adding please submit a pull request
class openvpn_as::package {

    case $facts['os']['name'] {
        'CentOS': {
        }
        'RedHat': {

        }
        'Debian': {

        }
        'Ubuntu': {
            $provider = 'dpkg'
            case $facts['lsbdistcodename'] {
                "xenial": {
                    case $facts['architecture'] {
                        'amd64': {
                            $sha256 = '2e982ce8b6d6702a157fc9b1680be75f08acc2cc0db1b49db1faa94c609340c8'
                            $installerURL = 'http://swupdate.openvpn.org/as/openvpn-as-2.5-Ubuntu16.amd_64.deb'
                            $localPath = '/tmp/openvpn-as-2.5-Ubuntu16.amd_64.deb'
                        }
                        'i386': {
                            $sha256 = 'f636ac072cfbf8f424810104ead0e1354e2f27ddb526bdcc2b4aa05db92f4ccc'
                            $installerURL = 'http://swupdate.openvpn.org/as/openvpn-as-2.5-Ubuntu16.i386.deb'
                            $localPath = '/tmp/openvpn-as-2.5-Ubuntu16.i386.deb'
                        }
                    }
                }
            }
        }
    }

    if ( $localPath ) {
        file { $localPath:
            ensure => 'file',
            checksum => 'sha256',
            checksum_value => $sha265,
            source => $installerURL
        }

        package { 'openvpn-as':
            ensure => 'installed',
            source => $localPath,
            provider => $provider,
            require => File[$localPath]
        }
    }
    else {
        notify {"${facts['os']['name']} ${facts['operatingsystemmajrelease']} ${facts['architecture']} is not supported":
            withpath => true,
        }
    }

}
