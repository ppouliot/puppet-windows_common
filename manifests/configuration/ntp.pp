# Class: windows::ntp
#
# This class configures NTP and the Timezone for a windows host
#
# Parameters: none
#
# Actions:
#
class windows_common::configuration::ntp (
    $timeserver = $windows_common::params::timeserver,
    $timezone   = $windows_common::params::timezone,
    $winpath    = $windows_common::params::winpath,
) inherits windows_common::params {

#    $timeserver = 'bonehed.lcs.mit.edu'
#    $timezone   = 'Eastern Standard Time'

  exec {'set_time_zone':
    command => "${windir}\\system32\\tzutil.exe /s \"${timezone}\"",
  }

  service { 'w32time':
    ensure => 'running',
    enable => true,
    before => Exec['stop_time'],
  }

  exec { 'stop_time':
    command => "${windir}\\system32\\net.exe stop w32time",
    before  => Exec['set_time_peer'],
    }

  exec { 'set_time_peer':
    command => "${windir}\\system32\\w32tm.exe /config /manualpeerlist:${timeserver},0x8 /syncfromflags:MANUAL",
    notify  => Exec['w32tm_update_time'],
  }

  exec {'w32tm_update_time':
    command     => "${windir}\\system32\\w32tm.exe /config /update",
    refreshonly => true,
  }

}

