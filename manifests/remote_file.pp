# == Define: windows_common::remote_file
#
# It downloads a remote file to a local path.
#
# === Parameters
#
# [*source*]
#   The remote location of the file. The current version only supports HTTP.
# [*destination*]
#   The full path on the local filesystem.
#
# === Examples
#
#  windows_common::remote_file { 'my-remote-file':
#    source      => "http://192.168.1.1/remote_file.ext",
#    destination => 'C:\Folder\local_copy.ext',
#  }
#
# === Authors
#
# === Copyright
#
define windows_common::remote_file($source, $destination){
  exec{ $name:
    command  => "$dm=([IO.Path]::GetDirectoryName($dest)); if(![IO.Directory]::Exists($dm)){md $dm}; (new-object Net.WebClient).DownloadFile(\'${source}\',\'${destination}\')",
    creates  => $destination,
    unless   => "exit !(Test-Path -Path '${destination}')",
    tries    => 5,
    provider => powershell,
  }
}
