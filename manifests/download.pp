# Class: windows::commands
#
# This module defines reused commands for windows
#
# Parameters: none
#
# Actions:
#


define download($url,$file){
  exec{ $name:
    path    => $::path,
    command => "powershell.exe -executionpolicy remotesigned -Command Invoke-WebRequest -UseBasicParsing -uri ${url} -OutFile ${file}",
    creates => "${::temp}\\${file}",
    cwd     => $::temp,
    unless  => "cmd.exe /c if not exist ${::temp}\\${file}",
  }
