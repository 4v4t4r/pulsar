# pulsar::priv::pam::magic
#
# Make sure root account isn't locked as part of account locking
#.

# Requires fact: pulsar_pamcommonauth
# Requires fact: pulsar_pamsystemauth

# Needs checking

class pulsar::priv::pam::magic::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::priv::pam::magic": }
    }
  }
}

class pulsar::priv::pam::magic::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /Debian|SuSE|Ubuntu/ {
        $fact = $pulsar_pamcommonauth
        $path = "/etc/pam.d/common-auth"
      }
      else {
        $fact = $pulsar_pamsystemauth
        $path = "/etc/pam.d/system-auth"
      }
      add_line_to_file { "auth\trequired\tpam_tally2.so onerr=fail no_magic_root": path => $path }
    }
  }
}
