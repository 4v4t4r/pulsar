# pulsar::accounting::sar
#
# The recommendation is to enable sar performance accounting.
# This will provide a normal performance baseline which will help identify
# unusual performance patterns, created through potential attacks via a
# password cracking program being executed or through a DoS attack etc.
# System accounting gathers periodic baseline system data, such as CPU
# utilization and disk I/O. Once a normal baseline for the system has been
# established, unauthorized activities, such as a password cracking being
# executed and activity outside of normal usage hours may be detected due
# to departure from the normal system performance baseline. It is recommended
# that the collection script is run on an hourly basis, every day, to help to
# detect any anomalies. It is also important to generate and review the system
# activity report on a daily basis.
#
# Refer to Section(s) 2.12.8 Page(s) 212-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8 Page(s) 71-72 CIS Oracle Solaris 10 Benchmark v5.1.0
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_crontab_adm
# Requires fact: pulsar_perms_var_adm_sa

class pulsar::accounting::sar::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel =~ /SunOS|AIX/ {
      init_message { "pulsar::accounting::sar": }
        if $kernel == "AIX" {
        install_package { "bos.acct": }
      }
    }
  }
}

class pulsar::accounting::sar::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel =~ /SunOS|AIX/ {
      check_dir_exists { "/var/adm/sa": exists => "yes" }
      check_dir_perms { "/var/adm/sa":
        mode  => "0750",
        owner => "adm",
        group => "adm",
      }
      if $kernel == "AIX" {
        $crontab_lines = [
          '0 8-17 * * 1-5 /usr/lib/sa/sa1 1200 3 &',
          '0 * * * 0,6 /usr/lib/sa/sa1 &',
          '0 18-7 * * 1-5 /usr/lib/sa/sa1 &',
          '5 18 * * 1-5 /usr/lib/sa/sa2 -s 8:00 -e 18:01 -i 3600 -ubcwyaqvm &'
        ]
      }
      if $kernel == "SunOS" {
        $crontab_lines = [
          '0,20,40 * * * * /usr/lib/sa/sa1',
          '45 23 * * * /usr/lib/sa/sa2 -s 0:00 -e 23:59 -i 1200 -A'
        ]
      }
      add_crontab_entry { $crontab_lines:
        fact => $pulsar_crontab_adm,
        path => "/var/spool/cron/crontabs/adm",
      }
    }
  }
}
