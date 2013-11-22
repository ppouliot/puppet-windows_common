class windows_common::configuration::rename_computer ($newname) {
  exec     => "Rename-Computer ${hostname} -newname ${newname}",
  provider => powershell,
}
