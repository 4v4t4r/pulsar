# pulsar::service::ssh::config
#
# Configure SSH
# SSH Protocol to 2
# SSH X11Forwarding
# SSH MaxAuthTries to 3
# SSH MaxAuthTriesLog to 0
# SSH IgnoreRhosts to yes
# SSH RhostsAuthentication to no
# SSH RhostsRSAAuthentication to no
# SSH root login
# SSH PermitEmptyPasswords to no
# SSH Banner
# Warning Banner for the SSH Service
#
# SSH is a secure, encrypted replacement for common login services such as
# telnet, ftp, rlogin, rsh, and rcp.
# It is strongly recommended that sites abandon older clear-text login
# protocols and use SSH to prevent session hijacking and sniffing of
# sensitive data off the network. Most of these settings are the default
# in Solaris 10 with the following exceptions:
# MaxAuthTries (default is 6)
# MaxAuthTriesLog (default is 3)
# Banner (commented out)
# X11Forwarding (default is "yes")
#
# SSH supports two different and incompatible protocols: SSH1 and SSH2.
# SSH1 was the original protocol and was subject to security issues.
# SSH2 is more advanced and secure.
# Secure Shell version 2 (SSH2) is more secure than the legacy SSH1 version,
# which is being deprecated.
#
# The X11Forwarding parameter provides the ability to tunnel X11 traffic
# through the connection to enable remote graphic connections.
# Disable X11 forwarding unless there is an operational requirement to use
# X11 applications directly. There is a small risk that the remote X11 servers
# of users who are logged in via SSH with X11 forwarding could be compromised
# by other users on the X11 server. Note that even if X11 forwarding is disabled
# that users can may be able to install their own forwarders.
#
# The MaxAuthTries paramener specifies the maximum number of authentication
# attempts permitted per connection. The default value is 6.
# Setting the MaxAuthTries parameter to a low number will minimize the risk of
# successful brute force attacks to the SSH server.
#
# The MaxAuthTriesLog parameter specifies the maximum number of failed
# authorization attempts before a syslog error message is generated.
# The default value is 3.
# Setting this parameter to 0 ensures that every failed authorization is logged.
#
# The IgnoreRhosts parameter specifies that .rhosts and .shosts files will not
# be used in RhostsRSAAuthentication or HostbasedAuthentication.
# Setting this parameter forces users to enter a password when authenticating
# with SSH.
#
# The RhostsAuthentication parameter specifies if authentication using rhosts
# or /etc/hosts.equiv is permitted. The default is no.
# Rhosts authentication is insecure and should not be permitted.
# Note that this parameter only applies to SSH protocol version 1.
#
# The RhostsRSAAuthentication parameter specifies if rhosts or /etc/hosts.equiv
# authentication together with successful RSA host authentication is permitted.
# The default is no.
# Rhosts authentication is insecure and should not be permitted, even with RSA
# host authentication.
#
# The PermitRootLogin parameter specifies if the root user can log in using
# ssh(1). The default is no.
# The root user must be restricted from directly logging in from any location
# other than the console.
#
# The PermitEmptyPasswords parameter specifies if the server allows login to
# accounts with empty password strings.
# All users must be required to have a password.
#
# The Banner parameter specifies a file whose contents must sent to the remote
# user before authentication is permitted. By default, no banner is displayed.
# Banners are used to warn connecting users of the particular site's policy
# regarding connection. Consult with your legal department for the appropriate
# warning banner for your site.
#
# Refer to Section(s) 6.2.1-15 Page(s) 127-137 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.2.1-15 Page(s) 147-159 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.2.1-15 Page(s) 130-141 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.2.1-15 Page(s) 121-131 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.9 Page(s) 57-60 CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 1.2 Page(s) 2-3 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.3-7 Page(s) 47-51 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.1.1-11 Page(s) 78-87 CIS Solaris 10 v5.1.0
#
# Fowarding: This one is optional, generally required for apps
#
# Refer to Section(s) 11.1 Page(s) 142-3 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_krb5
# Requires fact: pulsar_rcconf
# Requires fact: pulsar_sshd

class pulsar::service::ssh::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|FreeBSD|AIX/ {
      init_message { "pulsar::service::ssh::config": }
    }
  }
}

class pulsar::service::ssh::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|FreeBSD|AIX/ {
      $fact = $pulsar_admin_server
      if $fact =~ /[a-z]/ {
        $krb_lines = [ "GSSAPIAuthentication yes",
                       "GSSAPIKeyExchange yes",
                       "GSSAPIStoreDelegatedCredentials yes",
                       "UsePAM yes" ]
        add_line_to_file { $krb_lines: path => "sshd" }
      }
      $sshd_lines = [ "Protocol 2",
                      "X11Forwarding no",
                      "MaxAuthTries 3",
                      "MaxAuthTriesLog 0",
                      "RhostsAuthentication no",
                      "IgnoreRhosts yes",
                      "StrictModes yes",
                      "AllowTcpForwarding no",
                      "ServerKeyBits 1024",
                      "GatewayPorts no",
                      "RhostsRSAAuthentication no",
                      "PermitRootLogin no",
                      "PermitEmptyPasswords no",
                      "PermitUserEnvironment no",
                      "HostbasedAuthentication no",
                      "Banner /etc/issue",
                      "PrintMotd no",
                      "ClientAliveInterval 300",
                      "ClientAliveCountMax 0",
                      "LogLevel VERBOSE",
                      "RSAAuthentication no",
                      "UsePrivilegeSeparation yes",
                      "LoginGraceTime 120" ]
      add_line_to_file { $sshd_lines: path => "sshd" }
    }
  }
}
