# pulsar::service::smb::passwd
#
# Set the permissions of the smbpasswd file to 600, so that the contents of
# the file can not be viewed by any user other than root
# If the smbpasswd file were set to read access for other users, the lanman
# hashes could be accessed by an unauthorized user and cracked using various
# password cracking tools. Setting the file to 600 limits access to the file
# by users other than root.
#
# Refer to Section(s) 11.4-5 Page(s) 144-5 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_perms_etc_sfw_private_smbpasswd

class pulsar::service::smb::passwd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::smb::passwd": }
    }
  }
}

class pulsar::service::smb::passwd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      check_file_perms { "/etc/sfw/private/smbpasswd":
        mode  => "0600",
        owner => "root",
        group => "root",
      }
    }
  }
}
