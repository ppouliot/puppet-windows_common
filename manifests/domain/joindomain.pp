###############################################################
#
# Windows_Common::Domain::joindomain
#
# Description:
#    Definition to join a Windows machine to a Windows domain,
#    unless the machine is already a member of the specified
#    domain.
#
# Example usage:
#    windows_common::domain::joindomain: { 'testdom.net':
#      user_name => 'domainAdminUsername',
#      password  => 'domainAdminPassword',
#    }
#
#
###############################################################

define windows_common::domain::joindomain ( $user_name, $password ) {

  if $::osfamily == 'windows' {

    $code = " \
      \$secStr=ConvertTo-SecureString '${password}' -AsPlainText -Force; \
      if (-not \$?) { \
        write-error 'Error: Unable to convert password string to a secure string'; \
        exit 10; \
      } \
      \$creds=New-Object System.Management.Automation.PSCredential( '${user_name}', \$secStr ); \
      if (-not \$?) { \
        write-error 'Error: Unable to create PSCredential object'; \
        exit 20; \
      } \
      Add-Computer -DomainName ${name} -Cred \$creds; \
      if (-not \$?) { \
        write-error 'Error: Unable to join domain'; \
        exit 30; \
      } \
      exit 0"

    #
    # Use the Josh Cooper PowerShell provider
    #
    exec { 'join_domain':
      group     => Administrators,
      command   => "$code",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-WMIObject Win32_ComputerSystem).Domain -ne '$name') { exit 1 }",
    }
  }
}

