# pulsar::security::umask
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

# Requires fact: pulsar_skell_.login_umask
# Requires fact: pulsar_skell_.bash_profile_umask
# Requires fact: pulsar_skell_.bashrc_UMASK
# Requires fact: pulsar_login

# Needs to be fixed

class pulsar::security::umask::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::security::umask": }
    }
  }
}

class pulsar::security::umask::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux/ {
      $module_list = [
        'loginskel', 'profileskel', 'bashprofileskel',
        'bashrcskel', 'zshrcskel', 'kshrcskel',
        'tshrcskel'
      ]
      check_skel_values { $module_list: line=> "umask 077" }
    }
    if $kernel == 'SunOS' {
      add_line_to_file { "UMASK=077": path => "login" }
    }
  }
}
