# pulsar::service::svm::cli
#
# The Solaris Volume Manager, formerly known as Solstice DiskSuite, provides
# functionality for managing disk storage, disk arrays, etc. However, many
# systems without large storage arrays do not require that these services be
# enabled or may be using an alternate volume manager rather than the bundled
# SVM functionality. This service is disabled by default in the OS.
#
# Refer to Section(s) 2.2.8,12 Page(s) 28,32-3 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::svm::cli::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      if $kernelrelease =~ /10/ {
        init_message { "pulsar::service::svm::cli": }
      }
    }
  }
}

class pulsar::service::svm::cli::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      if $kernelrelease =~ /10/ {
        if $operatingsystemupdate < 4 {
          $service_list = [ 'svc:/system/metainit',
                            'svc:/system/mdmonitor',
                            'svc:/platform/sun4u/mpxio-upgrade' ]
        }
        else {
          $service_list = [ 'svc:/system/metainit',
                            'svc:/system/mdmonitor',
                            'svc:/system/device/mpxio-upgrade' ]
        }
        disable_service { $service_list: }
      }
    }
  }
}
