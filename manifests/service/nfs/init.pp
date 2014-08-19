# pulsar::service::nfs
#
# The Network File System (NFS) is one of the first and most widely
# distributed file systems in the UNIX environment. It provides the ability
# for systems to mount file systems of other servers through the network.
#
# Turn off NFS services
#
# Refer to Section(s) 3.8 Page(s) 64-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.8 Page(s) 77 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.8 Page(s) 67-8 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.7 Page(s) 57-8 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.7-11 Page(s) 11-3 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.5 Page(s) 39 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_system

class pulsar::service::nfs::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::nfs": }
    }
  }
}

class pulsar::service::nfs::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          $nfs_services = [
            'svc:/network/nfs/mapid:default',
            'svc:/network/nfs/status:default',
            'svc:/network/nfs/cbd:default',
            'svc:/network/nfs/nlockmgr:default',
            'svc:/network/nfs/client:default',
            'svc:/network/nfs/server:default'
          ]
          disable_service { $nfs_services: }
        }
        if $kernelrelease != '5.11' {
          disable_service { 'nfs.server': }
        }
        check_value { 'pulsar::service::nfs::portmon':
          path => "/etc/system",
          fact => $pulsar_system,
          line => 'set nfssrv:nfs_portmon = 1',
        }
      }
      if $kernel == 'Linux' {
        $nfs_services = [ 'nfs', 'nfslock', 'portmap', 'rpcbind' ]
        disable_service { $nfs_services: }
      }
    }
  }
}
