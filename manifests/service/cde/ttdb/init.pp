# pulsar::service::cde::ttdb
#
# The ToolTalk service enables independent CDE applications to communicate
# with each other without having direct knowledge of each other.
# Not required unless running CDE applications.
#
# Refer to Section(s) 2.1.1 Page(s) 17-8 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::cde::ttdb::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cde::ttdb": }
    }
  }
}

class pulsar::service::cde::ttdb::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == '5.10' {
        disable_service { "svc:/network/rpc/cde-ttdbserver:tcp": }
      }
    }
  }
}
