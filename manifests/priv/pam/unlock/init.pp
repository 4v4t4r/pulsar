# pulsar::priv::pam::unlock
#
# Audit time before account is unlocked after unsuccesful tries
#
# Lock out userIDs after n unsuccessful consecutive login attempts.
# The first sets of changes are made to the main PAM configuration files
# /etc/pam.d/system-auth and /etc/pam.d/password-auth. The second set of
# changes are applied to the program specific PAM configuration file
# (in this case, the ssh daemon). The second set of changes must be applied
# to each program that will lock out userID's.
# Set the lockout number to the policy in effect at your site.
#
# Refer to Section(s) 6.3.3 Page(s) 139-140 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.3 Page(s) 143-4 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_pampasswordauth
# Requires fact: pulsar_pamsystemauth

class pulsar::priv::pam::unlock::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      init_message { "pulsar::priv::pam::unlock": }
    }
  }
}

class pulsar::priv::pam::unlock::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      add_line_to_file { "auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900": path => "pampasswordauth"}
      add_line_to_file { "auth [success=1 default=bad] pam_unix.so": path => "pampasswordauth"}
      add_line_to_file { "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900": path => "pampasswordauth"}
      add_line_to_file { "auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900": path => "pampasswordauth"}
      add_line_to_file { "%auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900": path => "pamsystemauth"}
      add_line_to_file { "%auth [success=1 default=bad] pam_unix.so": path => "pamsystemauth"}
      add_line_to_file { "%auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900": path => "pamsystemauth"}
      add_line_to_file { "%auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900": path => "pamsystemauth"}
    }
  }
}
