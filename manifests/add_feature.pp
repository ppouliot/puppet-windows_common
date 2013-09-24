
  define add_windows_feature(){
    exec { "ps_add_feature_${name}":
      path    => $::path,
      command => "powershell.exe -executionpolicy remotesigned -Command Add-WindowsFeature -Name ${name}",
    }
  }
