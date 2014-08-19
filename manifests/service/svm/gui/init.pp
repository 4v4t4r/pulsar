# pulsar::service::svm::gui
#
# The Solaris Volume Manager, formerly Solstice DiskSuite, provides software
# RAID capability for Solaris systems. This functionality can either be
# controlled via the GUI administration tools provided with the operating
# system, or via the command line. However, the GUI tools cannot function
# without several daemons listed in Item 2.3.12 Disable Solaris Volume
# Manager Services enabled. If you have disabled Solaris Volume Manager
# Services, also disable the Solaris Volume Manager GUI.
# Note: Since these services use Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when these services are turned on.
#
# Since the same functionality that is in the GUI is available from the
# command line interface, administrators are strongly urged to leave these
# daemons disabled and administer volumes directly from the command line.
#
# Refer to Section(s) 2.2.13 Page(s) 33-4 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::svm::gui::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      if $kernelrelease =~ /10/ {
        init_message { "pulsar::service::svm::gui": }
      }
    }
  }
}

class pulsar::service::svm::gui::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      if $kernelrelease =~ /10/ {
        $service_list = [ 'svc:/network/rpc/mdcomm', 'svc:/network/rpc/meta',
                          'svc:/network/rpc/metamed', 'svc:/network/rpc/metamh' ]
        disable_service { $service_list: }
      }
    }
  }
}
