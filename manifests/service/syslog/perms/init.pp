# pulsar::service::syslog::perms
#
# Refer to Section(s) 11.7-8 Page(s) 146-7 CIS Solaris 10 v1.1.0
# Refer to Section(s) 5.1.2 Page(s) 105-6 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_readableorwritablebyothers_var_log_message
# Requires fact: pulsar_readableorwritablebyothers_var_log_kern
# Requires fact: pulsar_readableorwritablebyothers_var_log_syslog
# Requires fact: pulsar_readableorwritablebyothers_var_log_unused
# Requires fact: pulsar_readableorwritablebyothers_var_log_auth
# Requires fact: pulsar_readableorwritablebyothers_var_log_daemon
# Requires fact: pulsar_readableorwritablebyothers_var_log_lpr
# Requires fact: pulsar_readableorwritablebyothers_var_log_news
# Requires fact: pulsar_readableorwritablebyothers_var_log_uucp
# Requires fact: pulsar_readableorwritablebyothers_var_log_local0
# Requires fact: pulsar_readableorwritablebyothers_var_log_local1
# Requires fact: pulsar_readableorwritablebyothers_var_log_local2
# Requires fact: pulsar_readableorwritablebyothers_var_log_local3
# Requires fact: pulsar_readableorwritablebyothers_var_log_local4
# Requires fact: pulsar_readableorwritablebyothers_var_log_local5
# Requires fact: pulsar_readableorwritablebyothers_var_log_local6

# This code needs cleaning up

class pulsar::service::syslog::perms::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      init_message { "pulsar::service::syslog::perms": }
    }
  }
}

class pulsar::service::syslog::perms::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux|FreeBSD|SunOS/ {
      $file_list = [ '/var/log/message', '/var/log/kern', '/var/log/syslog',
                     '/var/log/unused', '/var/log/auth', '/var/log/daemon',
                     '/var/log/lpr', '/var/log/news', '/var/log/uucp',
                     '/var/log/local0', '/var/log/local1', '/var/log/local2',
                     '/var/log/local3', '/var/log/local4', '/var/log/local5',
                     '/var/log/local6' ]
      check_files { $file_list: type => "readableorwritablebyother"}
    }
  }
}
