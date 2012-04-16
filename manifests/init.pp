# Class: ntp
#
# This module manages ntp and is standard for all hosts
#
# Requires:
#   $ntpServerList must be passed in as a parameter
#
# Sample Usage:
#   class {
#       "ntp":
#           ntpServerList => [ "127.0.0.1" ];
#   }
#
class ntp( $ntpServerList ) {

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
    }

    file { "/etc/ntp.conf":
        mode    => "644",
        content => template("ntp/client-ntp.conf.erb"),
        notify  => Service['ntpd'],
        require => Package['ntp'],
    } # file

    service { 'ntpd':
		name => $ntp_service,
        ensure  => running,
        enable  => true,
        require => Package[$ntp_package],
    } # service
} # class ntp
