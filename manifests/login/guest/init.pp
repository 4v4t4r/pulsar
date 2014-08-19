# pulsar::login::guest
#
# ￼The Guest account allows a guest to log in to a Mac and use all of its
# services. When the guest logs out, the Mac clears most of whatever the guest
# did on the Mac. This allows one person to let another borrow the computer for
# a short period, and still protect information in other accounts on the Mac.
# The usage of a Guest account may give the Mac owner a false sense of security.
# If the guest has physical access to the Mac and the owner is not present,
# the guest could gain full access to the Mac. That said, use of the Guest
# account allows for quick and moderately safe computer sharing.
#
# Refer to Section(s) 1.4.2.7 Page(s) 29-30 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

# Requires fact: pulsar_dscl_guest_AuthenticationAuthority
# Requires fact: pulsar_dscl_guest_passwd
# Requires fact: pulsar_dscl_guest_UserShell

class pulsar::login::guest::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::login::guest_init": }
    }
  }
}

class pulsar::login::guest::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "Darwin" {
      check_dscl { "pulsar::login::guest::AuthenticationAuthority":
        user  => "Guest",
        param => "AuthenticationAuthority",
        value => ";basic;",
      }
      check_dscl { "pulsar::login::guest::passwd":
        user  => "Guest",
        param => "passwd",
        value => "*",
      }
      check_dscl { "pulsar::login::guest::UserShell":
        user  => "Guest",
        param => "UserShell",
        value => "/sbin/nologin",
      }
    }
  }
}
