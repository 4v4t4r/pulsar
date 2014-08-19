# pulsar::service::web
#
# Web Sharing uses the Apache 2.2.x Web server to turn the Mac into an HTTP/Web
# server. When Web Sharing is on, files in /Library/WebServer/Documents as well
# as each user's "Sites" folder are made available on the Web. As with File
# Sharing, Web Sharing is best left off and a dedicated, well-managed Web server
# is recommended.
# Web Sharing can be configured using the /etc/apache2/httpd.conf file
# (for global configurations). By default, Apache is fairly secure, but it can
# be made more secure with a few additions to the /etc/apache2/httpd.conf file.
#
# Refer to Section(s) 1.4.14.7 Page(s) 55-6 CIS Apple OS X 10.7 Benchmark v1.0.0
#.

# Requires fact: pulsar_apache

class pulsar::service::web::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::web": }
    }
  }
}

class pulsar::service::web::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      $httpd_lines = [ "ServerTokens Prod",
                       "ServerSignature Off",
                       "UserDir Disabled",
                       "TraceEnable Off" ]
      add_line_to_file { $httpd_lines: path => "apache" }
    }
  }
}
