# pulsar::service::newsyslog
#
# OSX writes information pertaining to system-related events to the
# path /var/log/system.log and has a configurable retention policy for
# this file.
#
# Archiving and retaining system.log for 30 or more days is beneficial in
# the event of an incident as it will allow the user to view the various
# changes to the system along with the date and time they occurred.
#
# Refer to Section 3.4-7 Page(s) 39-40 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.5-6 Page(s) 19 CIS FreeBSD Benchmark v1.0.5
#.

# Requires fact: pulsar_newsyslog

class pulsar::service::newsyslog::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Darwin|FreeBSD/ {
      init_message { "pulsar::service::newsyslog": }
    }
  }
}

class pulsar::service::newsyslog::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Darwin|FreeBSD/ {
      $path = "/etc/newsyslog.conf"
      if $kernel =~ /Darwin/ {
        add_line_to_file { "/var/log/system.log                     640  30    1000 *     J": path => "syslog" }
        add_line_to_file { "/var/log/secure.log                     640  30    1000 *     J": path => "syslog" }
        add_line_to_file { "/var/log/appfirewall.log                640  30    1000 *     J": path => "syslog" }
        add_line_to_file { "/var/log/install.log                    640  50    1000 *     J": path => "syslog" }
      }
      if $kernel =~ /FreeBSD/ {
        add_line_to_file { "/var/log/wtmp        root:wheel         600  7     1000 *     C": path => "syslog" }
        add_line_to_file { "/var/log/lastlog     root:wheel         600  7     1000 *     C": path => "syslog" }
        add_line_to_file { "/var/log/install.log root:wheel         600  7     100  @T23  C": path => "syslog" }
      }
    }
  }
}
