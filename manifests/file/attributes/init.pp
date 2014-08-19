# pulsar::file::attributes
#
# Extended attributes are implemented as files in a "shadow" file system that
# is not generally visible via normal administration commands without special
# arguments.
# Attackers or malicious users could "hide" information, exploits, etc.
# in extended attribute areas. Since extended attributes are rarely used,
# it is important to find files with extended attributes set.
#
# Refer to Section(s) 9.25 Page(s) 90-1 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.25 Page(s) 136-7 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_extendedattributes

class pulsar::file::attributes::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::file::attributes": }
    }
  }
}

class pulsar::file::attributes::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "SunOS" {
      check_extended_attributes { "pulsar::file::attributes": }
    }
  }
}
