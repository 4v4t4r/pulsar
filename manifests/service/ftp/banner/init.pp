
# pulsar::service::ftp::banner
#
# The action for this item sets a warning message for FTP users before they
# log in. Warning messages inform users who are attempting to access the
# system of their legal status regarding the system. Consult with your
# organization's legal counsel for the appropriate wording for your
# specific organization.

# Needs fixing

# Requires fact: pulsar_ftpd
# Requires fact: pulsar_ftpdbanner


class pulsar::service::ftp::banner::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ftp::banner": }
    }
  }
}

class pulsar::service::ftp::banner::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease == "5.10" {
          add_line_to_file { "Authorised users only": path => "ftpdbanner" }
        }
        if $kernelrelease == "5.11" {
          add_line_to_file { "DisplayConnect /etc/issue": path => "ftpdbanner" }
        }
      }
      if $kernel == 'Linux' {
        add_line_to_file { "DisplayConnect /etc/issue": path => "ftpdbanner" }
      }
    }
  }
}
