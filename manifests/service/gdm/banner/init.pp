# pulsar::service::gdm::banner
#
# Create Warning Banner for GNOME Users
#.

# Requires fact: pulsar_gdminit
# Requires fact: pulsar_gdm

# Needs Linux support
# http://www.cyberciti.biz/tips/howto-unix-linux-change-gnome-login-banner.html

class pulsar::service::gdm::banner::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::gdm::banner": }
    }
  }
}

class pulsar::service::gdm::banner::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        check_value { "pulsar::service::gdm::banner::Welcome":
          path  => "gdm",
          line  => "Welcome=Authorised users only",
          after => "[greeter]",
        }
        check_value { "pulsar::service::gdm::banner::RemoteWelcome":
          path  => "gdm",
          line  => "RemoteWelcome=Authorised users only",
          after => "[greeter]",
        }
      }
      if $kernelrelease == '5.11' {
        add_line_to_file { "   --title=\"Security Message\" --filename=/etc/issue": path => "gdminit" }
      }
    }
  }
}
