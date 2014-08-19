# pulsar::os::core::dump
#
# Solaris:
#
# Restrict Core Dumps to Protected Directory
#
# Although /etc/coreadm.conf isn't strictly needed,
# creating it and importing it makes it easier to
# enable or disable changes
#
# Example /etc/coreadm.conf
#
# COREADM_GLOB_PATTERN=/var/cores/core_%n_%f_%u_%g_%t_%p
# COREADM_INIT_PATTERN=core
# COREADM_GLOB_ENABLED=yes
# COREADM_PROC_ENABLED=no
# COREADM_GLOB_SETID_ENABLED=yes
# COREADM_PROC_SETID_ENABLED=no
# COREADM_GLOB_LOG_ENABLED=yes
#
# The action described in this section creates a protected directory to store
# core dumps and also causes the system to create a log entry whenever a regular
# process dumps core.
# Core dumps, particularly those from set-UID and set-GID processes, may contain
# sensitive data.
#
# Linux:
#
# A core dump is the memory of an executable program. It is generally used to
# determine why a program aborted. It can also be used to glean confidential
# information from a core file. The system provides the ability to set a soft
# limit for core dumps, but this can be overridden by the user.
#
# Setting a hard limit on core dumps prevents users from overriding the soft
# variable. If core dumps are required, consider setting limits for user groups
# (see limits.conf(5)). In addition, setting the fs.suid_dumpable variable to 0
# will prevent setuid programs from dumping core.
#
# Refer to Section(s) 1.6.1 Page(s) 44-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.1 Page(s) 50-1 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.6.1 Page(s) 47 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 4.1 Page(s) 35-6 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 4.1 Page(s) 16 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 3.1 Page(s) 25-6 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 3.2 Page(s) 61-2 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_limits
# Requires fact: pulsar_sysctl
# Requires fact: pulsar_coreadm

class pulsar::os::core::dump::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      init_message { "pulsar::os::core::dump": }
    }
  }
}

class pulsar::os::core::dump::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      if $kernel == "SunOS" {
        if $kernelrelease !~ /6/ {
          check_exec { "pulsar::os:core::dump::var_core":
            exec  => "coreadm -g /var/cores/core_%n_%f_%u_%g_%t_%p -e log -e global -e global-setid -d process -d proc-setid",
            check => "coreadm |head -1 |awk '{print \$5}'",
            value => "/var/cores/core_%n_%f_%u_%g_%t_%p",
          }
        }
      }
      if $kernel == "Linux" {
        disable_service { "kdump": }
        add_line_to_file { "* hard core ": path => "limits" }
        add_line_to_file { "fs.suid_dumpable = 0": path => "sysctl" }
      }
      if $kernel == "FreeBSD" {
        add_line_to_file { "kern.coredump = 0": path => "sysctl" }
      }
    }
  }
}
