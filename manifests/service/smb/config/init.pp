# pulsar::service::smb::config
#
# The smb.conf file is the configuration file for the Samba suite and contains
# runtime configuration information for Samba.
# All configuration files must be protected from tampering.
#
# Refer to Section(s) 11.2-3 Page(s) 143-4 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_perms_etc_samba_smb.conf

class pulsar::service::smb::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::smb::config": }
    }
  }
}

class pulsar::service::smb::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      check_file_perms { " /etc/samba/smb.conf":
        mode  => "0640",
        owner => "root",
        group => "root",
      }
    }
  }
}
