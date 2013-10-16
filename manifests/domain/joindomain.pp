#############################
#
# Windows_Common::Domain::joindomain
#
# Description:
#    Definition to join a Windows machine to a Windows domain.
#
# Example usage:
#    Windows_Common::Domain::joindomain': { 'testdom.net':
#      user_name => 'domainAdminUsername',
#      password => 'domainAdminPassword',
#    }
#
#############################

define windows_common::domain::joindomain ( $user_name, $password ) {

  if $::osfamily == 'windows' {

    $code = " \
      \$cs=Get-WMIObject Win32_ComputerSystem; \
      if (-not \$?) { \
        Write-Error 'Error - Unable to create Win32_ComputerSystem object'; \
        exit 10; \
      } \
      if (\$cs.Domain -eq \$domain_name) { \
        exit 0; \
      } \
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
      group   => Administrators,
      command  => "$code",
      provider => powershell,
      logoutput => true,
    }
  }
}

