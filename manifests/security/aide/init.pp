# pulsar::security::aide
#
# In some installations, AIDE is not installed automatically.
# Install AIDE to make use of the file integrity features to monitor critical
# files for changes that could affect the security of the system.
#
# Refer to Section(s) 1.3.1-2 Page(s) 34-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2 Page(s) 39-40 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2 Page(s) 36-7 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.3.1-2 Page(s) 112-3 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_prelinkstatus
# Requires fact: pulsar_prelink
# Requires fact: pulsar_crondaily_aide

# Needs fixing

class pulsar::security::aide::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::security::aide": }
      if $pulsar_prelink_status !~ /yes|YES/ {
        install_package { "aide": }
      }
      else {
        $warning = "Prelinking enabled"
        $command = "/usr/sbin/prelink -ua"
        if $pulsar_mode =~ /report/ {
          warning_message { $warning: fix => $command }
        }
        else {
          add_line_to_file { "PRELINKING=no": path => "prelink" }
          handle_exec { "pulsar::security::aide":
            check => "",
            fix   => $command,
            value => "",
          }
        }
      }
    }
  }
}

class pulsar::security::aide::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Linux" {
      if $prelink_status !~ /yes|YES/ {
        $line = "0 5 * * * /usr/sbin/aide --check"
        add_crontab_entry { $line:
          fact => $pulsar_crondaily_aide,
          path => "/etc/cron.daily/aide",
        }
      }
    }
  }
}
