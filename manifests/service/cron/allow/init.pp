# pulsar::service::cron::allow
#
# The cron.allow and at.allow files are a list of users who are allowed to run
# the crontab and at commands to submit jobs to be run at scheduled intervals.
# On many systems, only the system administrator needs the ability to schedule
# jobs.
# Note that even though a given user is not listed in cron.allow, cron jobs can
# still be run as that user. The cron.allow file only controls administrative
# access to the crontab command for scheduling and modifying cron jobs.
# Much more effective access controls for the cron system can be obtained by
# using Role-Based Access Controls (RBAC).
# Note that if System Accounting is enabled, add the user sys to the cron.allow
# file in addition to the root account.
#
# Refer to Section(s) 6.1.10-1 Page(s) 125-7 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.1.10-1 Page(s) 128-130 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.10-1 Page(s) 145-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.8 Page(s) 120 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.8-10,2.12.13-4 Page(s) 196-8,217-8 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.13 Page(s) 56-7 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.9 Page(s) 93-4 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_cronusers
# Requires fact: pulsar_crondeny
# Requires fact: pulsar_cronallow
# Requires fact: pulsar_perms_usr_lib_cron_at_allow
# Requires fact: pulsar_perms_usr_lib_cron_at_deny
# Requires fact: pulsar_perms_etc_cront.d_cron.allow
# Requires fact: pulsar_perms_etc_cront.d_at.allow
# Requires fact: pulsar_perms_etc_cron.d_cron.allow
# Requires fact: pulsar_perms_etc_cron.d_at.allow
# Requires fact: pulsar_perms_etc_cron.allow
# Requires fact: pulsar_perms_etc_at.allow
# Requires fact: pulsar_perms_var_cron_cron.allow
# Requires fact: pulsar_perms_var_at_at.allow

class pulsar::service::cron::allow::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      init_message { "pulsar::service::cron::allow": }
    }
  }
}

class pulsar::service::cron::allow::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      case $kernel {
        "FreeBSD": {
          check_cronallow_perms { "/var/cron/cron.allow": }
          check_cronallow_perms { "/var/cron/at.allow": }
          check_cronallow_perms { "/var/cron/cron.deny": }
          check_cronallow_perms { "/var/cron/at.deny": }
          $path = "/var/cron/cron.allow"
          check_cron_users { $pulsar_cronusers: path => $path }
        }
        "SunOS": {
          if $kernelrelease == "5.11" {
            check_cronallow_perms { "/etc/cron.d/cron.allow": }
            check_cronallow_perms { "/usr/lib/at.allow": }
            check_cronallow_perms { "/etc/cron.d/cron.deny": }
            check_cronallow_perms { "/usr/lib/at.deny": }
            $path = "/etc/cron.d/cron.allow"
            check_cron_users { $pulsar_cronusers: path => $path }
          }
          else {
            check_cronallow_perms { "/etc/cron.allow": }
            check_cronallow_perms { "/etc/at.allow": }
            check_cronallow_perms { "/etc/cron.deny": }
            check_cronallow_perms { "/etc/at.deny": }
            $path = "/etc/cron.allow"
            check_cron_users { $pulsar_cronusers: path => $path }
          }
        }
        "Linux": {
          check_cronallow_perms { "/etc/cron.allow": }
          check_cronallow_perms { "/etc/at.allow": }
          check_cronallow_perms { "/etc/cron.deny": }
          check_cronallow_perms { "/etc/at.deny": }
          $path = "/etc/cron.allow"
          check_cron_users { $pulsar_cronusers: path => $path }
        }
      }
    }
  }
}
