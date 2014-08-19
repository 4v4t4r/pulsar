# pulsar::login::delay
#
# The SLEEPTIME variable in the /etc/default/login file controls the number of
# seconds to wait before printing the "login incorrect" message when a bad
# password is provided.
# Delaying the "login incorrect" message can help to slow down brute force
# password-cracking attacks.
#.

# Requires fact: pulsar_login

# Needs fixing

class pulsar::login::delay::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::login::delay": }
    }
  }
}

class pulsar::login::delay::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "SLEEPTIME=4": path => "login" }
    }
  }
}
