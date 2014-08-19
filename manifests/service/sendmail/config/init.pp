# pulsar::service::sendmail::config
#
# If sendmail is set to local only mode, users on remote systems cannot
# connect to the sendmail daemon. This eliminates the possibility of a
# remote exploit attack against sendmail. Leaving sendmail in local-only
# mode permits mail to be sent out from the local system.
# If the local system will not be processing or sending any mail,
# disable the sendmail service. If you disable sendmail for local use,
# messages sent to the root account, such as for cron job output or audit
# daemon warnings, will fail to be delivered properly.
# Another solution often used is to disable sendmail's local-only mode and
# to have a cron job process all mail that is queued on the local system and
# send it to a relay host that is defined in the sendmail.cf file.
# It is recommended that sendmail be left in localonly mode unless there is
# a specific requirement to disable it.
#
# Refer to Section(s) 3.16 Page(s) 82 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.16 Page(s) 72-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 3.5 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.15 Page(s) 62-3 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.6 Page(s) 40-1 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2 Page(s) 15-6 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 19-20 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_crontab_root
# Requires fact: pulsar_sendmail
# Requires fact: pulsar_sendmailcf

class pulsar::service::sendmail::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX/ {
      init_message { "pulsar::service::sendmail::config": }
    }
  }
}

class pulsar::service::sendmail::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX/ {
      add_line_to_file { "O DaemonPortOptions=Port=smtp, Addr=127.0.0.1, Name=MTA": path => "sendmailcf" }
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/network/smtp:sendmail": }
        }
        else {
          disable_service { "sendmail": }
        }
        add_line_to_file { "QUEUEINTERVAL=15m": path => "sendmail" }
        add_line_to_file { "MODE=": path => "sendmail" }
      }
      if $kernel == "Linux" {
        disable_service { "sendmail": }
        add_line_to_file { "DAEMON=no": path => "sendmail" }
        add_line_to_file { "QUENE=1h": path => "sendmail" }
      }
      if $kernel == "FreeBSD" {
        add_line_to_file { "sendmail_enable = NO": path => "sendmail" }
        if $kernelrelease > 5 {
          add_line_to_file { "sendmail_submit_enable = NO": path => "sendmail" }
          add_line_to_file { "sendmail_outbound_enable = NO": path => "sendmail" }
          add_line_to_file { "sendmail_msp_quene_enable = NO": path => "sendmail" }
        }
      }
    }
  }
}
