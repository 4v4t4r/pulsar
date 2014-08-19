# pulsar::service::yum::config
#
# Make sure GPG checks are enabled for yum so that malicious sofware can not
# be installed.
#
# Refer to Section(s) 1.2.3 Page(s) 32 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.2.3 Page(s) 34 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.3 Page(s) 34 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_yum

class pulsar::service::yum::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      if $lsbdistid =~ /CentOS|Red/ {
        init_message { "pulsar::service::yum::config": }
      }
    }
  }
}

class pulsar::service::yum::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      if $lsbdistid =~ /CentOS|Red/ {
        add_line_to_file { "gpgcheck = 1": path => "yum" }
      }
    }
  }
}
