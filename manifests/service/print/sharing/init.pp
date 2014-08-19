# pulsar::service::print::sharing
#
# Disabling Printer Sharing mitigates the risk of attackers attempting to
# exploit the print server to gain access to the system.
#
# Refer to Section 2.2.4 Page(s) 19-20 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemprofiler_SPPrintersDataType_Shared

class pulsar::service::print::sharing::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::print::sharing": }
    }
  }
}

class pulsar::service::print::sharing::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_profiler { "SPPrintersDataType":
        param => "Shared",
        value => "No",
        exec  => "cupsctl --no-share-printers",
      }
    }
  }
}
