# pulsar::fs::mount::setuid
#
# If the volume manager (vold) is enabled to permit users to mount external
# devices, the administrator can force these file systems to be mounted with
# the nosuid option to prevent users from bringing set-UID programs onto the
# system via CD-ROMs, floppy disks, USB drives or other removable media.
# Removable media is one vector by which malicious software can be introduced
# onto the system. The risk can be mitigated by forcing use of the nosuid
# option. Note that this setting is included in the default rmmount.conf file
# for Solaris 8 and later.
#
# Refer to Section(s) 1.1.3,13,15 Page(s) 14-25 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.3,13,15 Page(s) 17-27 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.3,13,15 Page(s) 16-25 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1 Page(s) 21 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.2 Page(s) 76-7 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_fstab
# Requires fact: pulsar_configfile_fstab
# Requires fact: pulsar_rmmount

class pulsar::fs::mount::setuid::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      init_message { "pulsar::fs::mount::setuid": }
    }
  }
}

class pulsar::fs::mount::setuid::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD/ {
      if $kernel == "SunOS" {
        add_line_to_file { "mount * hsfs udfs ufs -o nosuid": path => "rmmount" }
      }
      if $kernel == "Linux" {
        check_mounts { "nosuid": }
      }
    }
  }
}
