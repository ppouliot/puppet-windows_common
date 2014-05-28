class windows_common::configuration::create_storage_pool ($storage_pool) {
  exec     => "New-StoragePool -StorageSubSystemID Get-StorageSubSystem.UniqueId -FriendlyName ${storage_pool} -PhysicalDisks (Get-PhysicalDisk -CanPool $true)",
  provider => powershell,
}
