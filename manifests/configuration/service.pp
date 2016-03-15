# === Define: windows_common::configuration::service
#
# Define a Windows service. It allows the user to create an manipulate
# Windows services.
#
# It covers functionality not implemented in the 'service'
# built-in type. To disable services, change the start type,... use the
# standard 'service' type.
#
# === Parameters
#
# [*ensure*]
#   Ensure value of the resource. Valid values are 'present' or 'absent'.
# [*display*]
#   Display name of the service. Defaults to the name of the service.
# [*description*]
#   Description of the service.
# [*binpath*]
#   Full command to be run by the service.
# [*user*]
#   Username that will run the service. Defaults to 'LocalSystem'. The type
#   will ensure that the user has the 'Log on as a service' right.
# [*password*]
#   Password of the user set. If 'LocalSystem', any value is allowed.
# == Examples
#
#  windows_common::configuration::service { 'app-service':
#    ensure      => present,
#    description => 'Description of App Service owned by LocalSystem',
#    display     => 'App Service',
#    binpath     => 'C:\App\service.exe',
#  }
#
#  windows_common::configuration::service { 'app-service':
#    description => 'Service owned by DOMAIN\account',
#    binpath     => 'C:\App\service.exe',
#    user        => 'DOMAIN\account',
#    password    => $user_password,
#  }
#
#  windows_common::configurationi::service { 'app-service':
#    ensure => absent,
#  }
#
define windows_common::configuration::service (
  $ensure       = present,
  $binpath      = undef,
  $display      = $name,
  $description  = 'Puppet managed service',
  $user         = 'LocalSystem',
  $password     = '',
){
  Exec { provider => powershell }

  case $ensure {
    present: {
      validate_string($binpath)

      exec { "create-windows-service-${name}":
        command => "& sc.exe create ${name} binpath= \" ${binpath} \" start= auto DisplayName= \"${display}\" ",
        unless  => "exit @(Get-Service ${name}).Count -eq 0",
      }

      registry_value { "HKLM\\System\\CurrentControlSet\\Services\\${name}\\ImagePath":
        ensure  => present,
        type    => expand,
        data    => $binpath,
        require => Exec["create-windows-service-${name}"],
      }

      registry_value { "HKLM\\System\\CurrentControlSet\\Services\\${name}\\DisplayName":
        ensure  => present,
        type    => string,
        data    => $display,
        require => Exec["create-windows-service-${name}"],
      }

      registry_value { "HKLM\\System\\CurrentControlSet\\Services\\${name}\\Description":
        ensure  => present,
        type    => string,
        data    => $description,
        require => Exec["create-windows-service-${name}"],
      }

      exec { "ensure-${name}-logon-rights":
        command     => template('windows_common/configuration/logon-as-service.ps1.erb'),
        refreshonly => true,
      }

      exec { "ensure-${name}-service-credentials":
        command => "& sc.exe config ${name} obj= ${user} password= ${password}",
        unless  => "exit ((Get-ItemProperty -Path HKLM:SYSTEM\\CurrentControlSet\\Services\\${name} -Name \"ObjectName\").ObjectName) -ne \"${user}\"",
        notify  => Exec["ensure-${name}-logon-rights"],
        require => Exec["create-windows-service-${name}"],
      }
    }
    absent: {
      exec { "delete-windows-service-${name}":
        command => "& sc.exe delete ${name}",
        unless  => "exit @(Get-Service ${name}).Count -ne 0",
      }
    }
    default: {
      fail('present parameter must be present or absent')
    }
  }
}
