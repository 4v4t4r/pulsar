# pulsar::fs::volfs
#
# The volume manager automatically mounts external devices for users whenever
# the device is attached to the system. These devices include CD-R, CD-RW,
# floppies, DVD, USB and 1394 mass storage devices. See the vold (1M) manual
# page for more details.
# Note: Since this service uses Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when this service is turned on.
#
# Allowing users to mount and access data from removable media devices makes
# it easier for malicious programs and data to be imported onto your network.
# It also introduces the risk that sensitive data may be transferred off the
# system without a log record. Another alternative is to edit the
# /etc/vold.conf file and comment out any removable devices that you do not
# want users to be able to mount.
#
# Refer to Section(s) 2.8 Page(s) 20-1 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::fs::volfs::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::fs::volfs": }
    }
  }
}

class pulsar::fs::volfs::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        if $kernelrelease == '5.11' {
          $service_list = [ 'svc:/system/filesystem/rmvolmgr', 'svc:/network/rpc/smserver' ]
        }
        if $kernelrelease == '5.10' {
          $service_list = [ 'svc:/system/filesystem/volfs', 'volmgt' ]
        }
        disable_service { $service_list: }
      }
    }
  }
}
