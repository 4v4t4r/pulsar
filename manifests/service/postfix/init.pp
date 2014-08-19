# pulsar::service::postfix
#
# Postfix is installed and active by default on SUSE.
# If the system need not accept remote SMTP connections, disable remote SMTP
# connections by setting SMTPD_LISTEN_REMOTE="no" in the /etc/sysconfig/mail
# SMTP connections are not accepted in a default configuration.
#
# Refer to Section 3.16 Page(s) 69-70 CIS CentOS Linux 6 Benchmark v1.0.0
#.

# Requires fact: pulsar_mail
# Requires fact: pulsar_postfix

class pulsar::service::postfix::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::postfix": }
    }
  }
}

class pulsar::service::postfix::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /SuSE/ {
        add_line_to_file { "SMTPD_LISTEN_REMOTE=no": path => "mail" }
      }
      if $lsbdistid =~ /CentOS|Red/ {
        add_line_to_file { "inet_interfaces = localhost": path => "postfix"}
      }
    }
  }
}
