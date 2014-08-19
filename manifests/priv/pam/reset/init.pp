# pulsar::priv::pam::reset
#
# Reset attempt counter to 0 after number of tries have been used
#
# Lock out userIDs after n unsuccessful consecutive login attempts.
# The first set of changes are made to the main PAM configuration file
# /etc/pam.d/system-auth.
# The second set of changes are applied to the program specific PAM
# configuration file (in this case, the ssh daemon).
# The second set of changes must be applied to each program that will
# lock out userID's.
#
# Set the lockout number to the policy in effect at your site.
#
# Locking out userIDs after n unsuccessful consecutive login attempts
# mitigates brute force password attacks against your systems.
#
# Refer to Section(s) 6.3.2 Page(s) 161-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.3.2 Page(s) 133-4 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_pamcommonauth
# Requires fact: pulsar_pamsystemauth

# Needs fixing and checking

class pulsar::priv::pam::reset::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::priv::pam::reset": }
    }
  }
}

class pulsar::priv::pam::reset::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /Debian|SuSE|Ubuntu/ {
        $path = "pamcommonauth"
      }
      else {
        $path = "pamsystemauth"
      }
    }
    add_line_to_file { "auth\trequired\tpam_tally2.so onerr=fail no_magic_root reset": path => $path }
  }
}
