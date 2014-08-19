# pulsar::login::retry
#
# Solaris:
#
# The RETRIES parameter is the number of failed login attempts a user is
# allowed before being disconnected from the system and forced to reconnect.
# When LOCK_AFTER_RETRIES is set in /etc/security/policy.conf, then the user's
# account is locked after this many failed retries (the account can only be
# unlocked by the administrator using the command:passwd -u <username>
# Setting these values helps discourage brute force password guessing attacks.
# The action specified here sets the lockout limit at 3, which complies with
# NSA and DISA recommendations. This may be too restrictive for some operations
# with large user populations.
#
# AIX:
#
# /etc/security/login.cfg - logininterval:
#
# Defines the time interval, in seconds, when the unsuccessful logins must
# occur to disable a port. This parameter is applicable to all tty connections
# and the system console.
# In setting the logininterval attribute, a port will be disabled if the
# incorrect password is entered a pre-defined number of times, set via
# logindisable, within this interval.
#
# /etc/security/login.cfg - logindisable:
#
# Defines the number of unsuccessful login attempts required before a port
# will be locked. This parameter is applicable to all tty connections and the
# system console.
# In setting the logindisable attribute, a port will be disabled if the
# incorrect password is entered a set number of times within a specified
# interval, set via logininterval.
#
# /etc/security/login.cfg - loginreenable:
#
# Defines the number of minutes after a port is locked when it will be
# automatically un-locked. This parameter is applicable to all tty connections
# and the system console.
# In setting the loginreenable attribute, a locked port will be automatically
# re-enabled once a given number of minutes have passed.
#
# /etc/security/login.cfg - logindelay:
#
# Defines the number of seconds delay between each failed login attempt.
# This works as a multiplier, so if the parameter is set to 10, after the
# first failed login it would delay for 10 seconds, after the second failed
# login 20 seconds etc.
# In setting the logindelay attribute, this implements a delay multiplier
# in-between unsuccessful login attempts.
#
# /etc/security/user - loginretries:
#
# Defines the number of attempts a user has to login to the system before
# their account is disabled.
# In setting the loginretries attribute, this ensures that a user can have a
# pre-defined number of attempts to get their password right, prior to locking
# the account.
#
# Refer to Section(s) 1.2.1-6 Page(s) 26-31 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.15 Page(s) 57-9 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.11 Page(s) 96-7 CIS Solaris 10 v5.1.0
#.o

# Requires fact: pulsar_login
# Requires fact: pulsar_user
# Requires fact: pulsar_policy

class pulsar::login::retry::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel =~ /SunOS|AIX/ {
      init_message { "pulsar::login::retry": }
    }
  }
}

class pulsar::login::retry::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel =~ /SunOS|AIX/ {
      if $kernel == "AIX" {
        check_lssec { "pulsar::login::retry_logininterval":
          file   => "/etc/security/login.cfg",
          stanza => "default",
          param  => "logininterval",
          value  => "300",
        }
        check_lssec { "pulsar::login::retry_logindisable":
          file   => "/etc/security/login.cfg",
          stanza => "default",
          param  => "logindisable",
          value  => "10",
        }
        check_lssec { "pulsar::login::retry_loginreenable":
          file   => "/etc/security/login.cfg",
          stanza => "default",
          param  => "loginreenable",
          value  => "360",
        }
        check_lssec { "pulsar::login::retry_logintimeout":
          file   => "/etc/security/login.cfg",
          stanza => "usw",
          param  => "logintimeout",
          value  => "30",
        }
        check_lssec { "pulsar::login::retry_logindelay":
          file   => "/etc/security/login.cfg",
          stanza => "default",
          param  => "logindelay",
          value  => "10",
        }
        check_lssec { "pulsar::login::retry_loginretries":
          file   => "/etc/security/user",
          stanza => "default",
          param  => "loginretries",
          value  => "3",
        }
      }
      if $kernel == "SunOS" {
        add_line_to_file { "RETRIES=3": path => "login" }
        add_line_to_file { "LOCK_AFTER_RETRIES=YES": path => "policy" }
      }
    }
  }
}
