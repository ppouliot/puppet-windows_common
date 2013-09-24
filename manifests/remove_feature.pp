  define remove_windows_feature{
    exec { "ps_remove_feature-${name}":
      path    => $::path,
      command => "powershell.exe -executionpolicy remotesigned -Command Remove-WindowsFeature -name ${name}",
    }
  }
