# Class: windows::common::rdp
#
# This module enables RDP access to the windows host and allows the more flexible method of connectivity
#
# Parameters: none
#
# Actions:
#

class windows_common::configuration::rdp(
$url       = undef,
){
  if $url == undef {
	  if $::architecture == 'x64' {
		$url_real = 'http://cdn.shopify.com/s/files/1/0206/6424/files/Vexasoft_Cmdlet_Library_x64.msi'
	  } else {
		$url_real = 'http://cdn.shopify.com/s/files/1/0206/6424/files/Vexasoft_Cmdlet_Library_x86.msi'
	  }
  }
  
  windows_common::remote_file{ 'Vexasoft_Cmdlet_Lib':
      source      => $url_real,
      destination => "${::temp}\\Vexasoft_Cmdlet_Lib.msi",
      before      => Package['Vexasoft_Cmdlet_Library_x64.msi'],
    }
	
  package { 'Vexasoft_Cmdlet_Library_x64.msi':
    ensure          => installed,
    source          => $url_real,
    install_options => ['/quiet', '/passive'],
	provider => 'windows',
  }
  
  exec { 'enable_rdp_connection':
    command => 'powershell.exe -executionpolicy remotesigned -Command (Get-WmiObject win32_TerminalServiceSetting -Namespace root\\cimv2\\TerminalServices).SetAllowTSConnections(1)',
  }

  exec { 'set_rdp_supported_clients':
    command => 'powershell.exe -executionpolicy remotesigned -Command Set-RemoteDesktopConfig -Enable -AllowOlderClients',
    require => Package['Vexasoft_Cmdlet_Library_x64.msi'],
  }

}
