# Class: windows::enable_auto_update
#
# This sets the windows to host to NOT update automatically
#
# Parameters: none
#
# Actions:
#

class windows_common::configuration::disable_auto_update {
  notify { 'Disabling Automatic Windows Updates': }
  exec { 'disable_automatic_updates':
    command => "${windir}\\system32\\cmd.exe /c cscript ${::windir}\\system32\\scregedit.wsf /AU 1",
  }
}
