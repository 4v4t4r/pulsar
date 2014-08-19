# pulsar::file::forward
#
# .forward files should be inspected to make sure information is not leaving
# the organisation
#
# The .forward file specifies an email address to forward the user's mail to.
# Use of the .forward file poses a security risk in that sensitive data may be
# inadvertently transferred outside the organization. The .forward file also
# poses a risk as it can be used to execute commands that may perform unintended
# actions.
#.

# Requires fact: pulsar_forwardfiles

# Needs fixing

class pulsar::file::forward::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX/ {
      init_message { "pulsar::file::forward": }
    }
  }
}

class pulsar::file::forward::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|FreeBSD|AIX/ {
      check_user_files { "forward": }
    }
  }
}
