class windows_common::enable_iscsi_initiator {
    notify { "Making sure the ISCSI Initiator Starts on Boot": }
    service { 'MSiSCSI':
      ensure => 'running',
      enable => true,
    }
}
