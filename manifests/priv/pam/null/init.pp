# pulsar::priv::pam::null
#
# Ensure null passwords are not accepted
#.

# Requires fact: pulsar_pamcommonauth
# Requires fact: pulsar_pamsystemauth

# Needs checking

class pulsar::priv::pam::null::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::priv::pam::null": }
    }
  }
}

class pulsar::priv::pam::null::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /Debian|SuSE|Ubuntu/ {
        $path = "pamcommonauth"
      }
      else {
        $path = "pamsystemauth"
      }
      remove_text_from_file { "nullok": path => $path }
    }
  }
}
