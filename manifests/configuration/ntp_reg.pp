# = Class windows_common::configuration::ntp_reg
#
# An attempt at seting ntp via puppet 
Class windows_common::configuration::ntp_reg ( $ntp_server ){

  registry_key {'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers':
    ensure => present,
  }

  registry_value {'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\0':
    type => string,
    data => $ntp_server,
    require => Registry_key['HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers'],
  }

  registry_key {'HKLM\SYSTEM\CurrentControlSet\services\W32Time\Parameters':
    ensure => present,
  }

  registry_value {'HKLM\SYSTEM\CurrentControlSet\services\W32Time\Parameters\NtpServer':
    type => string,
    data => $ntp_server,
    require => Registry_key['HKLM\SYSTEM\CurrentControlSet\services\W32Time\Parameters'],
  }

  service {'w32time': 
    enable => true,
    ensure => running,
    require => Registry_value[
      'HKLM\SYSTEM\CurrentControlSet\services\W32Time\Parameters\NtpServer',
      'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers\0'],
  }
}



