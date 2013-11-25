# == Define: windows_common::configuration::feature
#
# It allows the configuration of windows features.
#
# === Parameters
#
# [*name*]
#   The name of the feature to be manipulated. It defaults to the title of
#   the resource.
# [*ensure*]
#   This parameter specifies if the feature must be 'present' or 'absent' in
#   the system. It defaults to 'present'.
#
# === Examples
#
#  windows_common::configuration::feature { 'Hyper-V':
#    ensure => present,
#  }
#  
#  windows_common::configuration::feature { 'Telnet-Server':
#    ensure => absent,
#  }
#
# === Authors
#
#
# === Copyright
#
define windows_common::configuration::feature(
  $ensure = present,
){
  case $ensure {
    present: {
      exec { "add-windows-feature-${name}":
        command  => "Add-WindowsFeature -Name ${name}",
        unless   => "if(!(Get-WindowsFeature ${name}).Installed){ exit 1 }",
        provider => powershell,
      }
    }
    absent: {
      exec { "remove-windows-feature-${name}":
        command  => "Remove-WindowsFeature -name ${name}",
        unless   => "if((Get-WindowsFeature ${name}).Installed){ exit 1 }",
        provider => powershell,
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for windows_common::feature"
    }
  }
}
