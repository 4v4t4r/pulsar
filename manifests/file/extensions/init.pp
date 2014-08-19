# pulsar::file::extensions
#
# A filename extension is a suffix added to a base filename that indicates
# he base filename's file format.
# Visible filename extensions allows the user to identify the file type and
# the application it is associated with which leads to quick identification
# of misrepresented malicious files.
#
# Refer to Section 6.2 Page(s) 77-78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_NSGlobalDomain_AppleShowAllExtensions

class pulsar::file::extensions::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::file::extensions": }
    }
  }
}

class pulsar::file::extensions::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::file::extensions::AppleShowAllExtensions":
        pfile => "NSGlobalDomain",
        param => "AppleShowAllExtensions",
        value => "1",
      }
    }
  }
}
