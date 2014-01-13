# Class windows_common::params
#
# [ timeserver]
# [ timezone]
#
class windows_common::params {
#  $winpath = "${::systemroot}\system32",$::systemroot,$::winpath,$::path,

#  Exec { path => $::winpath }

#
# configuration::ntp
#
    $timeserver = 'pool.ntp.org'
    $timezone   = 'Eastern Standard Time'



}
