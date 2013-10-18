# == Class windows_common::configuration::enable_iscsi_iniator
#
# This class enables the iscsi initiator on a windows node
class windows_common::configuration::enable_iscsi_initiator {
    notify { "Making sure the ISCSI Initiator Starts on Boot": }
    service { 'MSiSCSI':
      ensure => 'running',
      enable => true,
    }
}
