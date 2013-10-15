
  define windows_common::client::map_drive ( $::drive_letter, $::server, $::share ){
    $drive_letter = $name
    exec { "mount-${name}":
      command => "net.exe use ${::drive_letter} \\\\${::server}\\${::share} /persist:yes",
      creates => "${drive_letter}/",
    }
  }
