# pulsar::service::gdm::lock
#
# The default timeout is 30 minutes of keyboard and mouse inactivity before a
# password-protected screen saver is invoked by the Xscreensaver application
# used in the GNOME windowing environment.
# Many organizations prefer to set the default timeout value to 10 minutes,
# though this setting can still be overridden by individual users in their
# own environment.
#.

# Requires fact: pulsar_xscreensaver

class pulsar::service::gdm::lock::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::gdm::lock": }
    }
  }
}

class pulsar::service::gdm::lock::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "timeout: 0:10:00": path => "xscreensaver" }
      add_line_to_file { "lockTimeout: 0:00:00": path => "xscreensaver" }
    }
  }
}
