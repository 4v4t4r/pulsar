# pulsar::security::download
#
# Apple maintains a list of known malicious software that is used during the
# safe download check to determine if a file contains malicious software,
# the list is updated daily by a background process.
#
# Refer to Section 2.6.3 Page(s) 29-30 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_mtime_System_Library_CoreServices_CoreTypes.bundle_Contents_Resources_XProtect.plist

class pulsar::security::download::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::security::download": }
    }
  }
}

class pulsar::security::download::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "Darwin" {
      check_file_mtime { "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.plist":
        max  => "30",
        min  => "",
        exec => "sudo /usr/libexec/XProtectUpdater",
      }
    }
  }
}
