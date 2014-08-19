# pulsar::password::strength
#
# Password policies are designed to force users to make better password choices
# when selecting their passwords.
#
# Solaris:
#
# Administrators may wish to change some of the parameters in this remediation
# step (particularly PASSLENGTH and MINDIFF) if changing their systems to use
# MD5, SHA-256, SHA-512 or Blowfish password hashes ("man crypt.conf" for more
# information). Similarly, administrators may wish to add site-specific
# dictionaries to the DICTIONLIST parameter.
# Sites often have differing opinions on the optimal value of the HISTORY
# parameter (how many previous passwords to remember per user in order to
# prevent re-use). The values specified here are in compliance with DISA
# requirements. If this is too restrictive for your site, you may wish to set
# a HISTORY value of 4 and a MAXREPEATS of 2. Consult your local security
# policy for guidance.
#
# OS X:
#
# Complex passwords contain one character from each of the following classes:
# English uppercase letters, English lowercase letters, Westernized Arabic
# numerals, and non- alphanumeric characters.
#
# FreeBSD
#
# MD5 encryption hashes are powerful, but in recent years other, more reliable
# ciphers have been adopted. Blowfish is one of the more powerful algorithms
# out there and fully supported for the FreeBSD password file database.
# Users will need to change their passwords for the settings to take effect as
# well as having the login.conf database rebuilt as is done here.
# There are interoperability issues with NIS and NIS+ configurations.
# In those cases, other algorithms are supported, including MD5 which is
# currently the default, and des. Administrators should also familiarize
# themselves with the FIPS-180 standard which contains information about US
# government accepted password hashes. Administrators working for the
# government may be required to use a different and more accepted algorithm
# over Blowfish.
#
# Refer to Section(s) 5.12-19 Page(s) 58-66 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 8.10 Page(s) 30 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 7.2 Page(s) 63-4 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.3 Page(s) 103-4 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_managednode
# Requires fact: pulsar_passwd
# Requires fact: pulsar_pwpolicy_requiresAlpha
# Requires fact: pulsar_pwpolicy_requiresSymbol
# Requires fact: pulsar_pwpolicy_maxMinutesUntilChangePassword
# Requires fact: pulsar_pwpolicy_minChars
# Requires fact: pulsar_pwpolicy_passwordCannotBeName
# Requires fact: pulsar_pwpolicy_minutesUntilFailedLoginReset
# Requires fact: pulsar_login


class pulsar::password::strength::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /SunOS|Darwin|FreeBSD/ {
      init_message { "pulsar::password::strength": }
    }
  }
}

class pulsar::password::strength::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /SunOS|Darwin|FreeBSD/ {
      if $kernel == "SunOS" {
        $lines = [ 'PASSLENGTH=8',
                   'NAMECHECK=YES',
                   'HISTORY=10',
                   'MINDIFF=3',
                   'MINALPHA=2',
                   'MINUPPER=1',
                   'MINLOWER=1',
                   'MINDIGIT=1',
                   'MINONALPHA=1',
                   'MAXREPEATS=0',
                   'WHITESPACE=0',
                   'DICTIONDBDIR=/var/passwd',
                   'DICTIONLIST=/usr/share/lib/dict/words', ]
        add_line_to_file { $lines: path => "passwd"}
      }
      if $kernel == "Darwin" {
        check_pwpolicy { "requiresAlpha": value => "1"}
        check_pwpolicy { "requiresSymbol": value => "1"}
        check_pwpolicy { "maxMinutesUntilChangePassword": value => "86400" }
        check_pwpolicy { "minChars": value => "15" }
        check_pwpolicy { "passwordCannotBeName": value => "1" }
        check_pwpolicy { "minutesUntilFailedLoginReset": value => "0" }
      }
      if $kernel == "FreeBSD" {
        add_line_to_file { "passwd_format = blf": path => "login" }
      }
    }
  }
}
