# pulsar::password::required
#
# Set PASSREQ to YES in /etc/default/login to prevent users from loging on
# without a password
#.

# Requires fact: pulsar_login

class pulsar::password::required::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::password::required": }
    }
  }
}

class pulsar::password::required::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "SunOS" {
      add_line_to_file { "PASSREQ=YES": path => "login" }
    }
  }
}
