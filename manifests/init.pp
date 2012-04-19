# = Class: ntp
#
# This module manages ntp and is standard for all hosts.
#
# == Parameters:
#
# $servers:: the servers to use for NTP.
#
# == Actions:
#   Install the ntp package, configure it and enable the service
#
# == Requires:
#
# == Sample Usage:
#
#   class {'ntp':
#     servers => [ '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org' ],
#   }
#
class ntp( $servers = undef ) {

    # the ntp package and service has a different name under RHEL vs. Debian
    case $operatingsystem {
        /(Debian|Ubuntu)/: { 
            $ntp_package = "ntp" 
            $ntp_service = "ntp" 
        }
        /(RedHat|CentOS|Fedora)/: { 
            $ntp_package = "ntp" 
            $ntp_service = "ntpd" 
        }
        /Solaris/: { 
            $ntp_package = "SUNWntpu" 
            $ntp_service = "ntp" 
        }
        default: { 
            $ntp_package = "ntp" 
            $ntp_service = "ntpd" 
        }
    } # case

    package { 'ntp':
      name => $ntp_package
    } ->

    service { 'ntpd':
        name   => $ntp_service,
        ensure => running,
        enable => true,
    } # service

    if $servers != undef {
      augeas { 'ntp':
        context => '/files/etc/ntp.conf',
        changes => template('ntp/augeas-server.erb'),
        require => Package['ntp'],
        notify  => Service['ntpd'],
      }
    }

} # class ntp
