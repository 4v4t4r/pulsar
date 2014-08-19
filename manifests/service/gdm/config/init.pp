# pulsar::service::gdm::config
#
# Gnome Display Manager should not be used on a server, but if it is it
# should be locked down to disable root access.
#
# [daemon]
#
# AutomaticLoginEnable
#
# AutomaticLoginEnable=false
#
# If the user given in AutomaticLogin should be logged in upon first bootup.
# No password will be asked. This is useful for single user workstations where
# local console security is not an issue. Also could be useful for public
# terminals, although there see TimedLogin.
#
# [security]
#
# AllowRoot
#
# AllowRoot=true
#
# Allow root (privilaged user) to log in through GDM. Set this to false if you
# want to disallow such logins.
#
# On systems that support PAM, this lineeter is not as useful as you can use
# PAM to do the same thing, and in fact do even more. However it is still
# followed, so you should probably leave it true for PAM systems.
#
# AllowRemoteRoot
#
# AllowRemoteRoot=true
#
# Allow root (privilaged user) to log in remotely through GDM. Set this to false
# if you want to disallow such logins. Remote logins are any logins that come in
# through the xdmcp.
#
# On systems that support PAM, this lineeter is not as useful as you can use
# PAM to do the same thing, and in fact do even more. However it is still
# followed, so you should probably leave it true for PAM systems.
#
# AllowRemoteAutoLogin
#
# AllowRemoteAutoLogin=false
#
# Allow the timed login to work remotely. That is, remote connections through
# XDMCP will be allowed to log into the "TimedLogin" user by letting the login
# window time out, just like the local user on the first console.
#
# Note that this can make a system quite insecure, and thus is off by default.
#
# RelaxPermissions
#
# RelaxPermissions=0
#
# By default GDM ignores files and directories writable to other users than the
# owner.
#
# Changing the value of RelaxPermissions makes it possible to alter this behaviour:
#
# 0 - Paranoia option. Only accepts user owned files and directories.
#
# 1 - Allow group writable files and directories.
#
# 2 - Allow world writable files and directories.
#
# RetryDelay
#
# RetryDelay=3
#
# The number of seconds GDM should wait before reactivating the entry field
# after a failed login.
#
# VerboseAuth
#
# VerboseAuth=true
#
# Specifies whether GDM should print authentication errors in the message field
# in the greeter. Unlike in the past having this option be true is no longer a
# security risk. It will not specify if username or password was wrong, as both
# result in the same error. However it will give a different error when for
# example root login is disallowed and root logs in, or if a user with a
# disabled login tries to log in (only after the user succeeds). No verbose
# information about the login is given until a user is verified.
#
# [xdmcp]
#
# DisplaysPerHost
#
# DisplaysPerHost=1
#
# To prevent attackers from filling up the pending queue, GDM will only allow
# one connection for each remote machine. If you want to provide display services
# to machines with more than one screen, you should increase the DisplaysPerHost
# value accordingly.
#
# Note that the number of connections from the local machine is unlimited.
# Only remote connections are limited by this number.
#
# Enable
#
# Enable=false
#
# Setting this to true enables XDMCP support allowing remote displays/X
# terminals to be managed by GDM.
#
# gdm listens for requests on UDP port 177. See the Port option for more
#  information.
#
# If GDM is compiled to support it, access from remote displays can be
# controlled using the TCP Wrappers library. The service name is gdm
#
# You should add
#
#    gdm:  .my.domain
#
# to your /etc/hosts.allow. See the hosts_access(5) man page for details.
#
# Please note that XDMCP is not a particularly secure protocol and that it is a
# good idea to block UDP port 177 on your firewall unless you really need it.
#
#
# [chooser]
#
# Broadcast
#
# Broadcast=true
#
# If true, the chooser will broadcast a query to the local network and collect
# responses. This way the chooser will always show all available managers on
# the network. If you need to add some hosts not local to this network, or if
# you don't want to use Broadcast, you can list them in the Hosts key.
#.

# Requires fact: pulsar_gdm
# Requires fact: pulsar_perms_configfile_gdm

class pulsar::service::gdm::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::gdm::config": }
    }
  }
}

class pulsar::service::gdm::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'Linux' {
      $file = "/etc/X11/gdm.conf"
      check_value { "pulsar::service::gdm::config::AllowRoot":
        path  => "gdm",
        line  => "AllowRoot=false",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::AllowRemoteRoot":
        path  => "gdm",
        line  => "AllowRemoteRoot=false",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::AllowRemoteAutoLogin":
        path  => "gdm",
        line  => "AllowRemoteAutoLogin=false",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::Use24Clock":
        path  => "gdm",
        line  => "Use24Clock=true",
        after => "[greeter]",
      }
      check_value { "pulsar::service::gdm::config::RetryDelay":
        path  => "gdm",
        line  => "RetryDelay=5",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::RelaxPermissions":
        path  => "gdm",
        line  => "RelaxPermissions=0",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::VerboseAuth":
        path  => "gdm",
        line  => "VerboseAuth=0",
        after => "[security]",
      }
      check_value { "pulsar::service::gdm::config::DisplaysPerHost":
        path  => "gdm",
        line  => "DisplaysPerHost=1",
        after => "[xdmcp]",
      }
      check_value { "pulsar::service::gdm::config::Enable":
        path  => "gdm",
        line  => "Enable=false",
        after => "[xdmcp]",
      }
      check_value { "pulsar::service::gdm::config::AutomaticLoginEnable":
        path  => "gdm",
        line  => "AutomaticLoginEnable=false",
        after => "[daemon]",
      }
      check_value { "pulsar::service::gdm::config::RebootCommand":
        path  => "gdm",
        line  => "RebootCommand=/bin/false",
        after => "[daemon]",
      }
      check_value { "pulsar::service::gdm::config::SuspendCommand":
        path  => "gdm",
        line  => "SuspendCommand=/bin/false",
        after => "[daemon]",
      }
      check_value { "pulsar::service::gdm::config::Broadcast":
        path  => "gdm",
        line  => "Broadcast=false",
        after => "[chooser]",
      }
      check_file_perms { "gdm":
        owner => "root",
        group => "root",
        mode  => "0644",
      }
    }
  }
}
