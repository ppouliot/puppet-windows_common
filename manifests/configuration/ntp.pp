# Class: windows::ntp
#
# This class configures NTP and the Timezone for a windows host
#
# Parameters: none
#
# Actions:
#

class windows_common::configuration::ntp(
    $timeserver = $windows_common::params::timeserver,
    $timezone   = $windows_common::params::timezone,
    $winpath    = $windows_common::params::winpath,
) inherits windows_common::params {

#    $timeserver = 'bonehed.lcs.mit.edu'
#    $timezone   = 'Eastern Standard Time'

  exec {'set_time_zone':
    command => "${windir}\\system32\\tzutil.exe /s \"${timezone}\"",
    before  => Service['w32time'],
  }

  service { 'w32time':
    ensure => 'running',
    enable => true,
    before => Exec['set_time_peer'],
  }

  exec { 'set_time_peer':
    command => "${windir}\\system32\\w32tm.exe /config /manualpeerlist:${timeserver} /syncfromflags:MANUAL",
    #notify  => Exec['w32tm_update_time'],
    before  => Exec['w32tm_update_time'],
    logoutput => true,
    timeout  => 60,
  }

  exec {'w32tm_update_time':
    command     => "${windir}\\system32\\w32tm.exe /config /update",
    #refreshonly => true,
    before      => Exec['w32tm_resync'],
    logoutput => true,
    timeout  => 60,
  }

  exec {'w32tm_resync':
    command    => "${windir}\\system32\\w32tm.exe /resync /nowait",
    logoutput => true,
    timeout  => 60,
    require => Exec['w32tm_update_time'],
  }
}

