# pulsar::service::sendmail::aliases
#
# Make sure sendmail aliases are configured appropriately.
# Remove decode/uudecode alias
#.

# Requires fact: pulsar_aliases
# Requires fact: pulsar_perms_aliases

class pulsar::service::sendmail::aliases::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::sendmail::aliases": }
    }
  }
}

class pulsar::service::sendmail::aliases::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      remove_line_from_file { "pulsar::service::sendmail::aliases":
        path  => "aliases",
        match => "decode",
      }
    }
  }
}
