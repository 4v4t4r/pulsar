# pulsar::fs::autofs
#
# The automount daemon is normally used to automatically mount NFS file systems
# from remote file servers when needed. However, the automount daemon can also
# be configured to mount local (loopback) file systems as well, which may
# include local user home directories, depending on the system configuration.
# Sites that have local home directories configured via the automount daemon
# in this fashion will need to ensure that this daemon is running for Oracle's
# Solaris Management Console administrative interface to function properly.
# If the automount daemon is not running, the mount points created by SMC will
# not be mounted.
# Note: Since this service uses Oracle's standard RPC mechanism, it is important
# that the system's RPC portmapper (rpcbind) also be enabled when this service
# is turned on.
#
# Refer to Section(s) 2.9 Page(s) 21 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.10 Page(s) 30 CIS Solaris 10 v5.1.0
# Refer to Section(s) 2.25 Page(s) 31 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::fs::autofs::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::fs::autofs": }
    }
  }
}

class pulsar::fs::autofs::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_name ="svc:/system/filesystem/autofs"
        }
        if $kernelrelease =~ /6|7|8|9/ {
          $service_name ="autofs"
        }
      }
      if $kernel == "Linux" {
        $service_name = "autofs"
      }
      disable_service { $service_name: }
    }
  }
}
