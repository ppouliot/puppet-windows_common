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

  # Validate Parameters
  validate_string($::username)
  validate_string($::password)
  validate_bool($::resetpw)
  validate_re($::fjoinoption, '\d+', 'fjoinoption parameter must be a number.')
  unless is_domain_name($::domain) {
    fail('Class[domain_membership] domain parameter must be a valid rfc1035 domain name')
  }

  # Use Either a "Secure String" password or an unencrypted password
  if $::secure_password {
    $_password = "(New-Object System.Management.Automation.PSCredential('user',(convertto-securestring '${::password}'))).GetNetworkCredential().password"
  }else{
    $_password = "\'${password}\'"
  }

  # Allow an optional OU location for the creation of the machine
  # account to be specified. If unset, we use the powershell representation
  # of nil, which is the `$null` variable.
  if $::machine_ou {
    validate_string($::machine_ou)
    $_machine_ou = "'${::machine_ou}'"
  }else{
    $_machine_ou = '$null'
  }


  case $::osfamily == 'windows' {

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
      command   => $::code,
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-WMIObject Win32_ComputerSystem).Domain -ne '${name}') { exit 1 }",
    }
  }
}

