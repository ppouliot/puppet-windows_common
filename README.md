puppet-windows_common
=====================

This module contains a set of types and classes that we have found useful while
doing different administration tasks on Microsoft Windows systems.

If you have a manifest that could make others administrator's lives easier and
it is not that important to be designed as an independent module, you are
welcome to open a pull request!

client::mapped_drive
--------------------

The define type **mapped_drive** allows you to map a share folder to a drive
letter.

    windows_common::client::mapped_drive { 'my-drive':
      ensure       => present,
      drive_letter => 'Z:',
      server       => 'public.host.com',
      share        => 'folder',
    }

Contributors
------------
 * Peter Pouliot <peter@pouliot.net>
 * Luis Fernandez Alvarez <luis.fernandez.alvarez@cern.ch>
 * Octavian Ciuhandu <ociuhandu@cloudbasesolutions.com>
 * Vijay Tripathi  <vijayt@microsoft.com>
 * Tim Rogers
