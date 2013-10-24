# Class: windows_common::domain::create
#
# This module defines reused commands for windows
#
# Parameters: none
#
# Actions:
#


class windows_common::domain::create{

  # Define: windows::commands::create_ad_domain
  # Create an Active Directory Domain
  #
  define create_ad_domain ( $domain_name, $netbios_name, $admin_passwd,){
    exec {'create_active_directory_domain':
      command => "Install-ADDSForest -CreateDNSDelegation:\$false -DatabasePath \"${::windir}\\NTDS\" -DomainMode \"Win2012\" -DomainName \"${domain_name}\" -DomainNetbiosName \"${netbios_name}\" -ForestMode \"Win2012\" -InstallDNS:\$true -LogPath \"${::windir}\\NTDS\" -SafeModeAdministratorPassword (convertto-securestring \"${admin_passwd}\" -asplaintext -force) -NoRebootOnCompletion:\$false -SysVolPath \"${::windir}\\SYSVOL\" -Force:\$true",
      onlyif => 'Import-Module ADDSDeployment',
	  provider	=> powershell,
    }
  }

}
