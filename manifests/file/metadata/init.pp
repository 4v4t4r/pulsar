# pulsar::file::metadata
#
# Auditing of File Metadata Modification Events
#
# The Solaris Audit service can be configured to record file metadata
# modification events for every process running on the system.
# This will allow the auditing service to determine when file ownership,
# permissions and related information is changed.
# This recommendation will provide an audit trail that contains information
# related to changes of file metadata. The Solaris Audit service is used to
# provide a more centralized and complete window into activities such as these.
#
# Refer to Section(s) 4.3 Page(s) 41-2 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_auditevent

# Needs fixing

class pulsar::file::metadata::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == 'SunOS' {
      init_message { "pulsar::file::metadata": }
    }
  }
}

class pulsar::file::metadata::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.11' {
        $audit_events = [ 'lck:AUE_CHMOD', 'lck:AUE_CHOW', 'lck:AUE_FCHMOD',
                          'lck:AUE_LCHMOWN', 'lck:AUE_ACLSET', 'lck:AUE_FACLSET' ]
        add_line_to_file { $audit_events: path => "auditevent" }
      }
    }
  }
}
