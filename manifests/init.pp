# == Class: windows_common
#
# Full description of class windows_common here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { windows_common:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class windows_common {
  notify {"WinPATH: ${winpath}":}
  notify {"AppData: ${appdata}":}
  notify {"Homedrive: ${homedrive}":}
  notify {"LocalAppdata: ${localappdata}":}
  notify {"ProgramData: ${programdata}":}
  notify {"ProgramFilesX64: ${programw6432}":}
  notify {"ProgramFilesX86: ${programx86}":}
  notify {"PowerShell ModulePath: ${psmodulepath}":}
  notify {"Public: ${public}":}
  notify {"SystemDrive: ${systemdrive}":}
  notify {"SystemRoot: ${systemroot}":}
  notify {"Temp: ${temp}":}
  notify {"Tmp: ${tmp}":}
  notify {"UserDomain: ${userdomain}":}
  notify {"UserDomainRoamingProfile: ${userdomain_roamingprofile}":}
  notify {"WinDir: ${windir}":}
  Exec{ path => "c:/windows/system32;${winpath};${::path}",}
}
