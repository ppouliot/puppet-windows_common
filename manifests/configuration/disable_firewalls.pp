# Class: windows_common::configuration::disable_firewalls
#
# This module disables the OS firewalls on the windows host
#
# Parameters: none
#
# Actions:
#
class windows_common::configuration::disable_firewalls {
  notify { 'Disabling All Windows Firewalls': }
  exec { 'disable_all_firewalls':
    command => 'Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False',
    provider  => powershell,
  }
}
