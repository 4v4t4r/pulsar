# pulsar::service::xgrid
#
# Turn of xgrid if not needed
#
# Refer to Section 2.4.14.14 Page(s) 62-63 CIS Apple OS X 10.5 Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::xgrid::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::xgrid": }
    }
  }
}

class pulsar::service::xgrid::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      $service_list = [ 'com.apple.xgridagentd.plist', 'com.apple.xgridcontrollerd' ]
      disable_service { $service_list: }
    }
  }
}
