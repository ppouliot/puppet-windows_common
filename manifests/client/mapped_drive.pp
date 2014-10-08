# == Define: windows_common::client::mapped_drive
#
# Creates a mapped drive to a shared folder
#
# === Parameters
#
# [*ensure*]
#   This parameter specifies if the drive must be 'present' or 'absent'. It
#   defaults to 'present'.
#
# [*drive_letter*]
#   Defines the drive letter. $title is the default value.
#
# [*server]
#   Server hosting the shared folder that will be mapped. It's mandatory.
#
# [*share*]
#   Share folder. It's a mandatory argument.
#
# === Examples
#
#   windows_common::client::mapped_drive { 'Z:':
#     server => 'public.host.com',
#     share  => 'folder',
#   }
#
#   windows_common::client::mapped_drive { 'custom-drive':
#     ensure       => present,
#     drive_letter => 'Z:',
#     server       => 'public.host.com',
#     share        => 'folder',
#   }
#
#   windows_common::client::mapped_drive { 'Z:':
#     ensure => absent,
#   }
#
define windows_common::client::mapped_drive (
    $ensure = present,
    $drive_letter = $title,
    $server,
    $share
  ){
  case $ensure {
    present: {
      exec { "mount-${name}":
        command => "net.exe use ${drive_letter} \\\\${server}\\${share} /persist:yes",
        creates => "${drive_letter}/",
        path    => $::path,
      }
    }
    absent: {
      exec { "unmount-${name}":
        command => "net.exe use ${drive_letter} /delete",
        path    => $::path,
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for windows_common::client::mapped_drive"
    }
  }
}
