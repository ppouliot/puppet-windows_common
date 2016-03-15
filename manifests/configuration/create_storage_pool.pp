# == Class: windows_common::configuration::create_storage_pool
class windows_common::configuration::create_storage_pool ($storage_pool) {
  exec     => "New-StoragePool -FriendlyName ${storage_pool} -StorageSubsystemFriendlyName "Storage Spaces*" -PhysicalDisks (Get-PhysicalDisk -CanPool \$true)",
  provider => powershell,
}
