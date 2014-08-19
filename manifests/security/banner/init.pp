# pulsar::security::banner
#
# Presenting a warning message prior to the normal user login may assist the
# prosecution of trespassers on the computer system. Changing some of these
# login banners also has the side effect of hiding OS version information and
# other detailed system information from attackers attempting to target
# specific exploits at a system.
# Guidelines published by the US Department of Defense require that warning
# messages include at least the name of the organization that owns the system,
# the fact that the system is subject to monitoring and that such monitoring
# is in compliance with local statutes, and that use of the system implies
# consent to such monitoring. It is important that the organization's legal
# counsel review the content of all messages before any system modifications
# are made, as these warning messages are inherently site-specific.
# More information (including citations of relevant case law) can be found at
# http://www.justice.gov/criminal/cybercrime/
#
# Refer to Section(s) 7.4 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.11,2.12.12 Page(s) 198,216 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 8.1.1 Page(s) 172-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 8.1 Page(s) 152-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 11.1 Page(s) 142-3 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1 Page(s) 68-9 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 8.1 Page(s) 111-2 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_perms_etc_motd
# Requires fact: pulsar_perms_etc_issue

class pulsar::security::banner::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX|Darwin/ {
      init_message { "pulsar::security::banner": }
    }
  }
}

class pulsar::security::banner::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX|Darwin/ {
      if $kernel =~ /AIX/ {
        $user  = "bin"
        $group = "bin"
      }
      else {
        $user  = "root"
        $group = "root"
      }
      $file_list = [ '/etc/motd', '/etc/issue' ]
      check_file_perms { "/etc/motd":
        mode  => "0644",
        owner => $user,
        group => $group,
      }
      check_file_perms { "/etc/issue":
        mode  => "0644",
        owner => $user,
        group => $group,
      }
    }
  }
}
