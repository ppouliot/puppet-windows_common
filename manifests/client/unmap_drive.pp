
  define windows_common::client::unmap_drive {
    $drive_letter = $name
    exec { "unmount-${name}":
      command     => "net.exe use ${drive_letter} /delete",
    }
  }

