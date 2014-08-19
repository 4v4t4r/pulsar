## pulsar::os::mesgn
#
# The "mesg n" command blocks attempts to use the write or talk commands to
# contact users at their terminals, but has the side effect of slightly
# strengthening permissions on the user's tty device.
# Note: Setting mesg n for all users may cause "mesg: cannot change mode"
# to be displayed when using su - <user>.
# Since write and talk are no longer widely used at most sites, the incremental
# security increase is worth the loss of functionality.
#
# Refer to Section(s) 8.9 Page(s) 29 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.12.7 Page(s) 211-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 7.5 Page(s) 66 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.8 Page(s) 108-9 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_loginskel
# Requires fact: pulsar_profileskel
# Requires fact: pulsar_bashprofileskel
# Requires fact: pulsar_bashrcskel
# Requires fact: pulsar_zshrcskel
# Requires fact: pulsar_kshrcskel
# Requires fact: pulsar_tshrcskel

class pulsar::os::mesgn::init {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      init_message { "pulsar::os::mesgn": }
    }
  }
}

class pulsar::os::mesgn::main {
  if $pulsar_modules =~ /os|operatingsystem|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      $module_list = [
        'loginskel', 'profileskel', 'bashprofileskel',
        'bashrcskel', 'zshrcskel', 'kshrcskel',
        'tshrcskel'
      ]
      check_skel_values { $module_list: line => "mesg n" }
    }
  }
}
