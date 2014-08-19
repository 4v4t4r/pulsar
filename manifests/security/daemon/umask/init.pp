# pulsar::security::daemon::umask
#
# Solaris:
#
# The umask (1) utility overrides the file mode creation mask as specified by
# the CMASK value in the /etc/default/init file. The most permissive file
# permission is mode 666 ( 777 for executable files). The CMASK value subtracts
# from this value. For example, if CMASK is set to a value of 022, files
# created will have a default permission of 644 (755 for executables).
# See the umask (1) manual page for a more detailed description.
# Note: There are some known bugs in the following daemons that are impacted by
# changing the CMASK parameter from its default setting:
# (Note: Current or future patches may have resolved these issues.
# Consult with your Oracle Support representative)
# 6299083 picld i initialise picld_door file with wrong permissions after JASS
# 4791006 ldap_cachemgr initialise i ldap_cache_door file with wrong permissions
# 6299080 nscd i initialise name_service_door file with wrong permissions after
# JASS
# The ldap_cachemgr issue has been fixed but the others are still unresolved.
# While not directly related to this, there is another issue related to 077
# umask settings:
# 2125481 in.lpd failed to print files when the umask is set 077
# Set the system default file creation mask (umask) to at least 022 to prevent
# daemon processes from creating world-writable files by default. The NSA and
# DISA recommend a more restrictive umask values of 077 (Note: The execute bit
# only applies to executable files). This may cause problems for certain
# applications- consult vendor documentation for further information.
# The default setting for Solaris is 022.
#
# Linux and FreeBSD
#
# Set the default umask for all processes started at boot time.
# The settings in umask selectively turn off default permission when a file is
# created by a daemon process.
# Setting the umask to 027 will make sure that files created by daemons will
# not be readable, writable or executable by any other than the group and
# owner of the daemon process and will not be writable by the group of the
# daemon process. The daemon process can manually override these settings if
# these files need additional permission.
#
# Refer to Section(s) 3.1 Page(s) 58-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 72 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.1 Page(s) 61-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 3.3 Page(s) 9-10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1 Page(s) 75-6 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_perms_initfile_umask
# Requires fact: pulsar_perms_configfile_init
# Requires fact: pulsar_init
# Requires fact: pulsar_umask
# Requires fact: pulsar_symlink_etc_rc2.d_S00umask

# Needs finishing

class pulsar::security::daemon::umask::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::security::daemon::umask": }
    }
  }
}

class pulsar::security::daemon::umask::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease == '5.11' {
          $umask_value = '022'
          check_exec { 'daemon_umask':
            exec  => "svccfg -s svc:/system/environment:init setprop umask/umask = astring:  '${umask_value}'",
            check => "svcprop -p umask/umask svc:/system/environment:init |grep '${umask_value}'",
            value => $umask_value,
          }
        }
        else {
          if $kernelrelease =~ /6|7/ {
            add_line_to_file { "umask 022": path => "umask" }
            check_file_perms { '/etc/init.d/umask':
              owner => 'root',
              group => 'sys',
              mode  => '0744',
            }
            check_symlink { '/etc/rc2.d/S00umask': target => '/etc/init.d/umask' }
          }
          else {
            add_line_to_file { "CMASK=022": path => "init" }
          }
        }
      }
    }
    if $kernel == 'Linux' {
      add_line_to_file { "umask 027": path => "init"}
      check_file_perms { '/etc/default/init':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }
    }
  }
}
