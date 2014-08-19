# pulsar::service::infrared
#
# A remote could be used to page through a document or presentation, thus
# revealing sensitive information. The solution is to turn off the remote
# and only turn it on when needed
#
# Refer to Section(s) 1.4.13.7 Page(s) 48-9 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

# Requires fact: pulsar_defaults_com.apple.driver.AppleIRController_DeviceEnabled

class pulsar::service::infrared::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::infrared::init": }
    }
  }
}

class pulsar::service::infrared::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_defaults { "pulsar::service::infrared::DeviceEnabled":
        pfile => "com.apple.driver.AppleIRController",
        param => "DeviceEnabled",
        value => "no",
      }
    }
  }
}
