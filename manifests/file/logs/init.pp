# pulsar::file::logs
#
# Check permission on log files under Linux. Make sure they are only readable
# by system accounts. This stops sensitive system information from being
# disclosed
#.

# Requires fact: pulsar_perms_var_log_boot.log
# Requires fact: pulsar_perms_var_log_btml
# Requires fact: pulsar_perms_var_log_cron
# Requires fact: pulsar_perms_var_log_dmesg
# Requires fact: pulsar_perms_var_log_ksyms
# Requires fact: pulsar_perms_var_log_httpd
# Requires fact: pulsar_perms_var_log_lastlog
# Requires fact: pulsar_perms_var_log_maillog
# Requires fact: pulsar_perms_var_log_mailman
# Requires fact: pulsar_perms_var_log_messages
# Requires fact: pulsar_perms_var_log_news
# Requires fact: pulsar_perms_var_log_pgsql
# Requires fact: pulsar_perms_var_log_rpm
# Requires fact: pulsar_perms_var_log_pkgs
# Requires fact: pulsar_perms_var_log_sa
# Requires fact: pulsar_perms_var_log_samba
# Requires fact: pulsar_perms_var_log_scrollkeeper.log

class pulsar::file::logs::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::file::logs": }
    }
  }
}

class pulsar::file::logs::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "Linux" {
      $log_files = [
        '/var/log/boot.log', '/var/log/btml', '/var/log/cron',
        '/var/log/dmesg', '/var/log/ksyms', '/var/log/httpd',
        '/var/log/lastlog', '/var/log/maillog', '/var/log/mailman',
        '/var/log/messages', '/var/log/news', '/var/log/pgsql',
        '/var/log/rpm', '/var/log/pkgs', '/var/log/sa',
        '/var/log/samba', '/var/log/scrollkeeper.log',
      ]
      check_file_perms { $log_files:
        owner  => 'root',
        group  => 'root',
        mode   => '0600',
      }
    }
  }
}
