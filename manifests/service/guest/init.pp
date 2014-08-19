# pulsar::service::guest
#
# If files need to be shared, a dedicated file server should be used.
# If file sharing on the client Mac must be used, then only authenticated
# access should be used. Guest access allows guest to access files they
# might not need access to.
#
# Refer to Section(s) 6.1.4 Page(s) 75-76 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.AppleFileServer_guestAccess
# Requires fact: pulsar_defaults_com.apple.smb.server_AllowGuestAccess

class pulsar::service::guest::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::guest::init": }
    }
  }
}

class pulsar::service::guest::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::service::guest::guestAccess":
        pfile => "com.apple.AppleFileServer",
        param => "guestAccess",
        value => "no",
      }
      check_defaults { "pulsar::service::guest::AllowGuestAccess":
        pfile => "com.apple.smb.server",
        param => "AllowGuestAccess",
        value => "no",
      }
    }
  }
}
