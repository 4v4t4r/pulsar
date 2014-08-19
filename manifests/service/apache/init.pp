# pulsar::service::apache
#
# Solaris:
#
# The action in this section describes disabling the Apache 1.x and 2.x web
# servers provided with Solaris 10. Both services are disabled by default.
# Run control scripts for Apache 1 and the NCA web servers still exist,
# but the services will only be started if the respective configuration
# files have been set up appropriately, and these configuration files do not
# exist by default.
# Even if the system is a Web server, the local site may choose not to use
# the Web server provided with Solaris in favor of a locally developed and
# supported Web environment. If the machine is a Web server, the administrator
# is encouraged to search the Web for additional documentation on Web server
# security.
#
# Linux:
#
# HTTP or web servers provide the ability to host web site content.
# The default HTTP server shipped with CentOS Linux is Apache.
# The default HTTP proxy package shipped with CentOS Linux is squid.
# Unless there is a need to run the system as a web server, or a proxy it is
# recommended that the package(s) be deleted.
#
# Refer to Section(s) 3.11,14 Page(s) 66-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.11,14 Page(s) 79-81 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.11,14 Page(s) 69-71 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.10,13 Page(s) 59,61 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.7 Page(s) 56-7 CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.10 Page(s) 21-2 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.11 Page(s) 30-2 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::apache::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      init_message { "pulsar::service::apache": }
    }
  }
}

class pulsar::service::apache::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin/ {
      if $kernel =~ /SunOS|Darwin/ {
        if $kernel == "Darwin" {
          $service_name = "apache"
        }
        if $kernel == 'SunOS' {
          if $kernelrelease == "5.9" {
            $service_name = "apache"
          }
          if $kernelrelease == "5.10" {
            $service_name = "svc:/network/http:apache2"
          }
          if $kernelrelease == "5.11" {
            $service_name="svc:/network/http:apache22"
          }
        }
        disable_service { $service_name: }
      }
      if $kernel == 'Linux' {
        $service_list = [ "httpd","apache","tomcat5","squid","prixovy" ]
        disable_service { $service_list: }
      }
    }
  }
}
